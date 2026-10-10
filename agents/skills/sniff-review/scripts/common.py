"""Shared subprocess and comparison helpers (standard library only)."""

import ast
import hashlib
import json
import os
import subprocess
import tempfile
import time


class CommandError(RuntimeError):
    def __init__(self, args, result):
        super().__init__(f"{args[0]} failed ({result.returncode}): {result.stderr.strip()}")
        try:
            self.code = json.loads(result.stderr).get("error", {}).get("code")
        except (ValueError, AttributeError):
            self.code = None


def bounded_run(args, cwd, timeout, limit):
    # Spool to disk, not Python memory. Check size while Git runs and read at
    # most limit+1 bytes even if it finishes between checks.
    with tempfile.TemporaryFile() as output, tempfile.TemporaryFile() as errors:
        process = subprocess.Popen(args, cwd=cwd, stdout=output, stderr=errors)
        deadline = time.monotonic() + timeout
        try:
            while True:
                if os.fstat(output.fileno()).st_size > limit:
                    raise ValueError("Comparison exceeds 4 MiB; select a smaller review scope")
                remaining = deadline - time.monotonic()
                if remaining <= 0:
                    raise subprocess.TimeoutExpired(args, timeout)
                try:
                    process.wait(timeout=min(0.02, remaining))
                    break
                except subprocess.TimeoutExpired:
                    pass
            output.seek(0)
            data = output.read(limit + 1)
            if len(data) > limit:
                raise ValueError("Comparison exceeds 4 MiB; select a smaller review scope")
            errors.seek(0)
            return subprocess.CompletedProcess(args, process.returncode, data.decode("utf8"),
                                               errors.read(65536).decode("utf8", errors="replace"))
        finally:
            if process.poll() is None:
                process.kill()
                process.wait()


def run(*args, cwd=None, json_output=False, allowed=(0,), timeout=60, input_text=None, max_output_bytes=None):
    if max_output_bytes is None:
        result = subprocess.run(args, cwd=cwd, input=input_text, capture_output=True, text=True, timeout=timeout)
    else:
        if input_text is not None:
            raise ValueError("Bounded diff commands must not need stdin")
        result = bounded_run(args, cwd, timeout, max_output_bytes)
    if result.returncode not in allowed:
        raise CommandError(args, result)
    return json.loads(result.stdout) if json_output else result.stdout


def herdr(*args):
    output = run("herdr", *args)
    return json.loads(output)["result"] if output.strip() else {}


def snapshot(repo, revisions=None):
    flags = ["--no-ext-diff", "--no-textconv", "--no-color", "--src-prefix=a/", "--dst-prefix=b/"]
    limit = 4 * 1024 * 1024
    if revisions is not None and ".." not in revisions:
        chunks = [run("git", "show", "--format=", "--diff-merges=first-parent", *flags, revisions, "--",
                      cwd=repo, max_output_bytes=limit)]
    else:
        chunks = [run("git", "diff", *flags, revisions or "HEAD", "--", cwd=repo, max_output_bytes=limit)]
    size = len(chunks[0].encode("utf8"))
    if size > limit:
        raise ValueError("Comparison exceeds 4 MiB; select a smaller review scope")
    if revisions is None:
        paths = run("git", "ls-files", "--others", "--exclude-standard", "-z", cwd=repo)
        paths = list(filter(None, paths.split("\0")))
        if len(paths) > 250:
            raise ValueError("More than 250 untracked files; exclude generated files before reviewing")
        for path in paths:
            chunk = run("git", "diff", *flags, "--no-index", "--", "/dev/null", path,
                        cwd=repo, allowed=(0, 1), max_output_bytes=limit - size)
            size += len(chunk.encode("utf8"))
            if size > limit:
                raise ValueError("Comparison exceeds 4 MiB; select a smaller review scope")
            chunks.append(chunk)
    return "".join(chunks)


def resolve_revisions(repo, expression):
    def commit(ref):
        return run("git", "rev-parse", "--verify", "--end-of-options",
                   f"{ref or 'HEAD'}^{{commit}}", cwd=repo).strip()

    if ".." not in expression:
        return commit(expression)
    separator = "..." if "..." in expression else ".."
    parts = expression.split(separator)
    if len(parts) != 2:
        raise ValueError("Supply a single Git revision or an explicit A..B / A...B comparison")
    return separator.join(commit(part) for part in parts)


def diff_path(value):
    if value.startswith('"'):
        value = ast.literal_eval(value)
        try:
            value = value.encode("latin1").decode("utf8")
        except (UnicodeError, ValueError):
            pass
    else:
        value = value.split("\t", 1)[0]
    return value[2:] if value.startswith(("a/", "b/")) else value


def read_session(context):
    review = run("hunk", "session", "review", context["session"], "--include-patch", "--json",
                 json_output=True)["review"]
    if review.get("inputKind") != "patch" or review.get("sourceLabel") != context["diff"]:
        raise ValueError("Hunk no longer shows the captured patch; start a fresh review")
    if review.get("sessionId") != context["session"]:
        raise ValueError("Hunk returned a different session; refusing to add comments")
    return review


def review_digest(review):
    patches = sorted((file["path"], file["patch"]) for file in review["files"])
    return hashlib.sha256(json.dumps(patches, ensure_ascii=False).encode("utf8")).hexdigest()


def diff_digest(diff):
    return hashlib.sha256(diff.encode("utf8")).hexdigest()
