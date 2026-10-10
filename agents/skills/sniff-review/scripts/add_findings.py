#!/usr/bin/env python3
"""Validate and anchor must-fix findings, then batch local Hunk notes."""

import argparse
import json
from pathlib import Path
import re
import sys

from common import diff_digest, diff_path, read_session, review_digest, run, snapshot


def parse_diff(diff):
    files = {}
    old_path = new_path = None
    old_no = new_no = None
    for line in diff.split("\n"):
        if line.startswith("diff --git "):
            old_path = new_path = None
            old_no = new_no = None
        elif old_no is None and line.startswith("--- "):
            old_path = diff_path(line[4:])
        elif new_no is None and line.startswith("+++ "):
            new_path = diff_path(line[4:])
            path = old_path if new_path == "/dev/null" else new_path
            files.setdefault(path, {"old": [], "new": [], "hunks": 0, "hunk_targets": []})
        elif line.startswith("@@ "):
            match = re.match(r"@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@", line)
            if match:
                old_no, _, new_no, new_count = match.groups()
                old_no, new_no = int(old_no), int(new_no)
                path = old_path if new_path == "/dev/null" else new_path
                files[path]["hunks"] += 1
                target = ("old", old_no, old_no) if new_count == "0" else ("new", new_no, new_no)
                files[path]["hunk_targets"].append(target)
        elif old_no is not None and new_no is not None:
            path = old_path if new_path == "/dev/null" else new_path
            if line.startswith("-"):
                files[path]["old"].append((old_no, line[1:]))
                old_no += 1
            elif line.startswith("+"):
                files[path]["new"].append((new_no, line[1:]))
                new_no += 1
            elif line.startswith(" "):
                files[path]["old"].append((old_no, line[1:]))
                files[path]["new"].append((new_no, line[1:]))
                old_no += 1
                new_no += 1
    return files


def prepare(findings, files):
    if not isinstance(findings, list):
        raise ValueError("Findings must be a JSON array")
    result = []
    for item in findings:
        if not isinstance(item, dict):
            raise ValueError("Each finding must be an object")
        path, body = item.get("file"), item.get("body")
        side, code = item.get("side", "new"), item.get("code")
        severity, fix = item.get("severity"), item.get("recommendation")
        if path not in files or side not in ("old", "new"):
            raise ValueError(f"Finding path/side is outside the diff: {path!r}/{side!r}")
        if not all(isinstance(x, str) and x.strip() for x in (body, fix)):
            raise ValueError("Every finding needs a nonempty body and recommendation")
        if severity not in ("critical", "high", "medium", "low"):
            raise ValueError("Every finding needs a valid severity")
        note = {"filePath": path, "summary": f"{severity}\n{body.strip()}\n↳ fix: {fix.strip()}"}
        hunk = item.get("hunk")
        if hunk is not None:
            if code is not None or item.get("line") is not None:
                raise ValueError("Supply a hunk OR a code quote, not both")
            if type(hunk) is not int or not 1 <= hunk <= files[path]["hunks"]:
                raise ValueError(f"Hunk is outside the diff for {path!r}")
            note["hunkNumber"] = hunk
        else:
            if not isinstance(code, str) or not code.strip():
                raise ValueError("Every line finding needs an exact, nonblank code quote")
            matches = [no for no, text in files[path][side] if text == code]
            hint = item.get("line")
            line = matches[0] if len(matches) == 1 else (
                hint if type(hint) is int and hint in matches else None)
            if line is None:
                raise ValueError(f"Code quote is unmatched or ambiguous in {path!r}; provide an exact hint or explicit hunk")
            note["oldLine" if side == "old" else "newLine"] = line
        result.append(note)
    return result


def key(comment, files):
    if "hunkNumber" in comment:
        target = files[comment["filePath"]]["hunk_targets"][comment["hunkNumber"] - 1]
    else:
        target = None
        for side in ("new", "old"):
            if f"{side}Line" in comment:
                line = comment[f"{side}Line"]
                target = (side, line, line)
                break
            if comment.get(f"{side}Range") is not None:
                target = (side, *comment[f"{side}Range"])
                break
    return (comment.get("filePath"), target, comment.get("author"),
            comment.get("body", comment.get("summary")))


def validate_context(context, captured):
    if diff_digest(captured) != context["diff_digest"]:
        raise ValueError("Captured patch file changed; start a fresh review")
    if run("git", "rev-parse", "HEAD", cwd=context["repo"]).strip() != context["head"]:
        raise ValueError("Checkout HEAD changed since launch; start a fresh review")
    if context.get("target") and run("git", "status", "--porcelain", cwd=context["repo"]).strip():
        raise ValueError("PR checkout now has local changes; start a fresh review")
    review = read_session(context)
    if review_digest(review) != context["review_digest"]:
        raise ValueError("Hunk's loaded comparison changed; start a fresh review")
    if snapshot(context["repo"], context["revisions"]) != captured:
        raise ValueError("Comparison changed since launch; start a fresh review")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("context", type=Path)
    parser.add_argument("findings", type=Path)
    args = parser.parse_args()
    added = skipped = 0
    try:
        context = json.loads(args.context.read_text())
        captured = Path(context["diff"]).read_bytes().decode("utf8")
        validate_context(context, captured)
        files = parse_diff(captured)
        findings = prepare(json.loads(args.findings.read_text()), files)
        if any(item["filePath"] not in context["files"] for item in findings):
            raise ValueError("A finding targets a file outside the selected Hunk session")
        existing = run("hunk", "session", "comment", "list", context["session"], "--type", "all", "--json",
                       json_output=True)["comments"]
        seen = {key(comment, files) for comment in existing}
        batch = []
        for item in findings:
            item["author"] = context["author"]
            identity = key(item, files)
            if identity in seen:
                skipped += 1
                continue
            batch.append(item)
            seen.add(identity)
        if batch:
            validate_context(context, captured)
            run("hunk", "session", "comment", "apply", context["session"], "--stdin", "--json",
                input_text=json.dumps({"comments": batch}), json_output=True)
            added = len(batch)
        print(json.dumps({"added": added, "skipped_duplicates": skipped}))
    except Exception as error:
        print(f"sniff-review: stopped after {added} note(s) added: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
