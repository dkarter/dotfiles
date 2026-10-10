#!/usr/bin/env python3
"""Open Hunk and a persistent reviewer in a Herdr 80/20 layout."""

import argparse
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import sys
import tempfile
import time
from common import CommandError, diff_digest, herdr, read_session, resolve_revisions, review_digest, run, snapshot


def wait_for(check, message, timeout=30):
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        value = check()
        if value:
            return value
        time.sleep(0.2)
    raise RuntimeError(message)


def processes(pane):
    return herdr("pane", "process-info", "--pane", pane)["process_info"]


def is_shell(pane):
    info = processes(pane)
    return all(p["pid"] == info["shell_pid"] for p in info["foreground_processes"])


def start_reviewer(name, kind, pane):
    deadline = time.monotonic() + 5
    while True:
        try:
            herdr("agent", "start", name, "--kind", kind, "--pane", pane)
            return
        except CommandError as error:
            if error.code != "agent_pane_busy" or time.monotonic() >= deadline:
                raise
            time.sleep(0.1)


def select_session(patch):
    rows = run("hunk", "session", "list", "--json", json_output=True)["sessions"]
    matches = [row for row in rows if row.get("inputKind") == "patch" and row.get("sourceLabel") == patch]
    if len(matches) > 1:
        raise RuntimeError("Multiple Hunk sessions show this patch; refusing to guess")
    return matches[0] if matches else None


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode", choices=["pr", "local"])
    parser.add_argument("target", nargs="?")
    parser.add_argument("--cwd", default=os.getcwd())
    parser.add_argument("--revisions")
    parser.add_argument("--remote")
    parser.add_argument("--agent")
    parser.add_argument("--hwt-bin", default="hwt", help="HWT checkout executable")
    parser.add_argument("--focus", action="store_true")
    args = parser.parse_args()
    if os.environ.get("HERDR_ENV") != "1" or not os.environ.get("HERDR_PANE_ID"):
        parser.error("Run inside a Herdr-managed agent pane")
    if args.mode == "pr" and (not args.target or args.revisions):
        parser.error("PR mode requires a target and does not accept --revisions")
    if args.mode == "local" and (args.target or args.remote):
        parser.error("Local mode does not accept a PR target or --remote")
    for tool in ["git", "herdr", "hunk"] + ([args.hwt_bin] if args.mode == "pr" else []):
        if not shutil.which(tool):
            parser.error(f"Missing dependency: {tool}")
    caller = herdr("agent", "get", os.environ["HERDR_PANE_ID"])["agent"]
    kind = args.agent or caller["agent"]
    repo = run("git", "rev-parse", "--show-toplevel", cwd=args.cwd).strip()
    state = {"repo": repo, "agent_kind": kind}
    try:
        workspace = caller["workspace_id"]
        viewer = None
        revisions = resolve_revisions(repo, args.revisions) if args.revisions else None
        if args.mode == "pr":
            target = args.target
            match = re.fullmatch(r"([^/#]+/[^/#]+)#([1-9][0-9]*)", target)
            if match:
                target = f"https://github.com/{match[1]}/pull/{match[2]}"
            if not (re.fullmatch(r"[1-9][0-9]*", target) or
                    re.fullmatch(r"https://github\.com/[^/]+/[^/]+/pull/[1-9][0-9]*", target)):
                raise RuntimeError("Supply a GitHub PR URL, positive number, or owner/repo#number")
            cmd = [args.hwt_bin, "checkout", "--cwd", repo, "--reuse", "--json"]
            if args.remote:
                cmd.extend(["--remote", args.remote])
            result = run(*cmd, "--", target, json_output=True, timeout=600)
            repo = result["path"]
            workspace = result["workspace_id"]
            state.update(repo=repo, workspace_id=workspace)
            number = result["identity"]["number"]
            url = result["identity"]["url"]
            head = run("git", "rev-parse", f"refs/hwt/reviews/pr-{number}/head", cwd=repo).strip()
            if run("git", "rev-parse", "HEAD", cwd=repo).strip() != head:
                raise RuntimeError("Reused checkout is behind the PR head; update it explicitly before retrying")
            if run("git", "status", "--porcelain", cwd=repo).strip():
                raise RuntimeError("PR checkout has local changes; refusing to review a different tree")
            base = run("git", "rev-parse", f"refs/hwt/reviews/pr-{number}/base", cwd=repo).strip()
            revisions = f"{base}...{head}"
            state["target"] = url
            # A reused workspace may contain the user's agents or editors. Give
            # the review its own tab instead of taking over any of their panes.
            if not result["reused"]:
                viewer = result["pane_id"]
                tab = herdr("pane", "get", viewer)["pane"]["tab_id"]
        head = run("git", "rev-parse", "HEAD", cwd=repo).strip()
        diff = snapshot(repo, revisions)
        if not diff.strip():
            raise RuntimeError("Nothing to review in the selected comparison")
        review_dir = Path(tempfile.mkdtemp(prefix="sniff-review-")).resolve()
        state["review_dir"] = str(review_dir)
        diff_path = review_dir / "diff.patch"
        diff_path.write_bytes(diff.encode("utf8"))
        if viewer is None:
            created = herdr("tab", "create", "--workspace", workspace,
                            "--cwd", repo, "--label", "AI review", "--no-focus")
            viewer = created["root_pane"]["pane_id"]
            tab = created["tab"]["tab_id"]
        state.update(workspace_id=workspace, viewer_pane=viewer, tab_id=tab)
        wait_for(lambda: is_shell(viewer), "New viewer pane did not reach a shell prompt")
        herdr("pane", "run", viewer, shlex.join(["hunk", "patch", str(diff_path), "--agent-notes"]))
        session = wait_for(lambda: select_session(str(diff_path)),
                           "No Hunk session appeared for the captured patch; inspect the viewer pane")
        context = state | {"diff": str(diff_path), "revisions": revisions,
                           "session": session["sessionId"], "author": f"{kind} reviewer", "head": head,
                           "diff_digest": diff_digest(diff)}
        saved = read_session(context)
        context["files"] = sorted(file["path"] for file in saved["files"])
        context["review_digest"] = review_digest(saved)
        # Fail if code changed while the viewer was starting, not after the
        # reviewer has spent time reasoning about a different checkout.
        if run("git", "rev-parse", "HEAD", cwd=repo).strip() != head or snapshot(repo, revisions) != diff:
            raise RuntimeError("Comparison changed during startup; start a fresh review")
        if state.get("target") and run("git", "status", "--porcelain", cwd=repo).strip():
            raise RuntimeError("PR checkout changed during startup; start a fresh review")
        split = herdr("pane", "split", "--pane", viewer, "--direction", "right",
                      "--ratio", "0.8", "--cwd", repo, "--no-focus")
        agent_pane = split["pane"]["pane_id"]
        name = "sniff-" + re.sub(r"[^a-z0-9_-]", "-", agent_pane.lower())
        state.update(agent_pane=agent_pane, agent_name=name[:32], session=session["sessionId"])
        context.update(agent_pane=agent_pane, agent_name=state["agent_name"], tab_id=tab)
        context_path = review_dir / "context.json"
        context_path.write_text(json.dumps(context, indent=2))
        wait_for(lambda: is_shell(agent_pane), "New agent pane did not reach a shell prompt")
        start_reviewer(state["agent_name"], kind, agent_pane)
        skill = Path(__file__).resolve().parents[1]
        prompt = (skill / "references/reviewer.md").read_text()
        prompt += "\n\n" + (skill / "references/review-priorities.md").read_text()
        prompt += "\n\nRequired explain-simply skill: " + str(skill.parent / "explain-simply/SKILL.md")
        prompt += "\n\nReview context:\n" + json.dumps(context, indent=2)
        prompt += "\n\nSave findings to " + str(review_dir / "findings.json")
        prompt += "\nAdd local Hunk notes using:\n" + shlex.join([
            "python3", str(skill / "scripts/add_findings.py"), str(context_path),
            str(review_dir / "findings.json")])
        herdr("agent", "prompt", state["agent_name"], prompt)
        if args.focus:
            herdr("tab", "focus", tab)
        print(json.dumps(state | {"status": "reviewing"}, indent=2))
    except Exception as error:
        print(json.dumps(state | {"status": "failed", "error": str(error)}, indent=2), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
