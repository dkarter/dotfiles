#!/usr/bin/env python3
"""Test Hunk review orchestration and anchoring without starting agents."""

import contextlib
import io
import json
import os
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch


SKILL = Path(__file__).resolve().parents[1] / "agents/skills/sniff-review"
sys.path.insert(0, str(SKILL / "scripts"))
import add_findings
import common
import launch


DIFF = """diff --git a/src/example.py b/src/example.py
--- a/src/example.py
+++ b/src/example.py
@@ -2,3 +2,4 @@
 same()
-old()
+new()
+same()
 same()
diff --git a/gone.py b/gone.py
--- a/gone.py
+++ /dev/null
@@ -1 +0,0 @@
-deleted()
"""


def review_model(source="/diff.patch"):
    return {"sessionId": "session-1", "inputKind": "patch", "sourceLabel": source,
            "files": [{"path": "src/example.py", "patch": DIFF.split("diff --git a/gone.py")[0]},
                      {"path": "gone.py", "patch": "diff --git a/gone.py" + DIFF.split("diff --git a/gone.py")[1]}]}


def finding(**overrides):
    return {"file": "src/example.py", "code": "new()", "severity": "high",
            "body": "Concrete trigger causes the failure.", "recommendation": "Handle the failure.",
            **overrides}


class AnchoringTest(unittest.TestCase):
    def setUp(self):
        self.files = add_findings.parse_diff(DIFF)

    def test_unique_quote_ignores_wrong_hint_and_supports_old_side(self):
        result = add_findings.prepare([
            finding(line=999), finding(file="gone.py", side="old", code="deleted()")], self.files)
        self.assertEqual(result[0]["newLine"], 3)
        self.assertEqual(result[1]["oldLine"], 1)

    def test_exact_hint_resolves_repeated_quote(self):
        result = add_findings.prepare([finding(code="same()", line=5)], self.files)
        self.assertEqual(result[0]["newLine"], 5)

    def test_ambiguous_or_unmatched_quotes_are_not_guessed(self):
        for row in [finding(code="same()"), finding(code="same()", line=100), finding(code=" new()", line=3)]:
            with self.subTest(row=row), self.assertRaisesRegex(ValueError, "unmatched or ambiguous"):
                add_findings.prepare([row], self.files)

    def test_explicit_hunk_for_broader_issue(self):
        row = finding(hunk=1)
        del row["code"]
        result = add_findings.prepare([row], self.files)
        self.assertEqual(result[0]["hunkNumber"], 1)
        self.assertNotIn("newLine", result[0])

    def test_invalid_findings_are_rejected(self):
        for row in [finding(file="example.py"), finding(side="other"), finding(severity="urgent"),
                    finding(recommendation=""), finding(code=""), finding(code=42),
                    finding(hunk=1), finding(hunk=9, code=None), finding(hunk=True, code=None)]:
            with self.subTest(row=row), self.assertRaises(ValueError):
                add_findings.prepare([row], self.files)

    def test_multiple_hunks_and_marker_like_code(self):
        diff = """diff --git a/file b/file
--- a/file
+++ b/file
@@ -1 +1 @@
-gone
+++ code
@@ -50 +60 @@
 context
"""
        files = add_findings.parse_diff(diff)
        self.assertEqual(files["file"]["new"], [(1, "++ code"), (60, "context")])
        self.assertEqual(files["file"]["hunks"], 2)

    def test_quoted_and_space_paths(self):
        self.assertEqual(add_findings.diff_path('"b/na\\303\\257ve.py"'), "naïve.py")
        self.assertEqual(add_findings.diff_path("b/file with spaces.py"), "file with spaces.py")

    def test_source_unicode_line_separator_does_not_change_anchors(self):
        code = 'const text = "a\u2028b\fc";'
        diff = f"diff --git a/file b/file\n--- a/file\n+++ b/file\n@@ -0,0 +1 @@\n+{code}\n"
        files = add_findings.parse_diff(diff)
        self.assertEqual(files["file"]["new"], [(1, code)])
        note = add_findings.prepare([finding(file="file", code=code)], files)[0]
        self.assertEqual(note["newLine"], 1)


class InjectionTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.diff = self.root / "diff.patch"
        self.diff.write_text(DIFF)
        self.review = review_model(str(self.diff))
        self.context = self.root / "context.json"
        self.context.write_text(json.dumps({"repo": "/repo", "diff": str(self.diff),
                                           "head": "sha", "revisions": None,
                                           "files": ["src/example.py", "gone.py"],
                                           "review_digest": common.review_digest(self.review),
                                           "diff_digest": common.diff_digest(DIFF),
                                           "session": "session-1", "author": "opencode reviewer"}))
        self.findings = self.root / "findings.json"
        self.findings.write_text(json.dumps([finding(), finding()]))

    def invoke(self, existing=None, changed=False, reload=False, snapshot_results=None):
        calls = []

        def run(*args, **kwargs):
            calls.append((args, kwargs))
            if args[:3] == ("git", "rev-parse", "HEAD"):
                return "sha\n"
            if args[:4] == ("hunk", "session", "comment", "list"):
                return {"comments": existing or []}
            return {"result": {}}

        review = self.review | {"files": []} if reload else self.review
        with patch.object(sys, "argv", ["add_findings.py", str(self.context), str(self.findings)]), \
                patch.object(add_findings, "snapshot", return_value="changed" if changed else DIFF,
                             side_effect=snapshot_results), \
                patch.object(add_findings, "read_session", return_value=review), \
                patch.object(add_findings, "run", side_effect=run), \
                contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(io.StringIO()):
            status = add_findings.main()
        return status, calls

    def applies(self, calls):
        return [(args, kwargs) for args, kwargs in calls if args[:4] == ("hunk", "session", "comment", "apply")]

    def test_duplicates_add_once_with_author_in_stdin_batch(self):
        status, calls = self.invoke()
        applies = self.applies(calls)
        self.assertEqual(status, 0)
        self.assertEqual(len(applies), 1)
        args, kwargs = applies[0]
        batch = json.loads(kwargs["input_text"])["comments"]
        self.assertEqual(len(batch), 1)
        self.assertEqual(batch[0]["author"], "opencode reviewer")
        self.assertEqual(batch[0]["newLine"], 3)
        self.assertIn("--stdin", args)
        self.assertNotIn("--focus", args)

    def test_existing_hunk_comment_is_not_duplicated(self):
        row = add_findings.prepare([finding()], add_findings.parse_diff(DIFF))[0]
        existing = [{"filePath": row["filePath"], "hunkIndex": 0, "newRange": [3, 3],
                     "author": "opencode reviewer", "body": row["summary"]}]
        status, calls = self.invoke(existing=existing)
        self.assertEqual(status, 0)
        self.assertEqual(self.applies(calls), [])

    def test_same_text_by_human_is_not_treated_as_agent_duplicate(self):
        row = add_findings.prepare([finding()], add_findings.parse_diff(DIFF))[0]
        existing = [{"filePath": row["filePath"], "author": "human", "body": row["summary"]}]
        status, calls = self.invoke(existing=existing)
        self.assertEqual(status, 0)
        self.assertEqual(len(self.applies(calls)), 1)

    def test_same_text_at_different_lines_adds_both_notes(self):
        self.findings.write_text(json.dumps([
            finding(code="same()", line=2), finding(code="same()", line=5)]))
        status, calls = self.invoke()
        self.assertEqual(status, 0)
        batch = json.loads(self.applies(calls)[0][1]["input_text"])["comments"]
        self.assertEqual([row["newLine"] for row in batch], [2, 5])

    def test_existing_note_at_different_line_does_not_suppress_finding(self):
        row = add_findings.prepare([finding()], add_findings.parse_diff(DIFF))[0]
        existing = [{"filePath": row["filePath"], "newRange": [2, 2],
                     "author": "opencode reviewer", "body": row["summary"]}]
        status, calls = self.invoke(existing=existing)
        self.assertEqual(status, 0)
        self.assertEqual(len(self.applies(calls)), 1)

    def test_old_and_new_line_targets_are_distinct(self):
        self.findings.write_text(json.dumps([
            finding(code="same()", line=2), finding(code="same()", side="old", line=2)]))
        status, calls = self.invoke()
        self.assertEqual(status, 0)
        batch = json.loads(self.applies(calls)[0][1]["input_text"])["comments"]
        self.assertEqual(len(batch), 2)
        self.assertEqual(batch[0]["newLine"], 2)
        self.assertEqual(batch[1]["oldLine"], 2)

    def test_existing_hunk_target_is_not_duplicated(self):
        self.findings.write_text(json.dumps([finding(hunk=1, code=None)]))
        row = add_findings.prepare([finding(hunk=1, code=None)], add_findings.parse_diff(DIFF))[0]
        existing = [{"filePath": row["filePath"], "hunkIndex": 0, "newRange": [2, 2],
                     "author": "opencode reviewer", "body": row["summary"]}]
        status, calls = self.invoke(existing=existing)
        self.assertEqual(status, 0)
        self.assertEqual(self.applies(calls), [])

    def test_existing_deleted_hunk_target_is_not_duplicated(self):
        note = finding(file="gone.py", hunk=1, code=None)
        self.findings.write_text(json.dumps([note]))
        row = add_findings.prepare([note], add_findings.parse_diff(DIFF))[0]
        existing = [{"filePath": row["filePath"], "hunkIndex": 0, "oldRange": [1, 1],
                     "author": "opencode reviewer", "body": row["summary"]}]
        status, calls = self.invoke(existing=existing)
        self.assertEqual(status, 0)
        self.assertEqual(self.applies(calls), [])

    def test_changed_checkout_or_reloaded_viewer_posts_nothing(self):
        for kwargs in [{"changed": True}, {"reload": True}]:
            with self.subTest(kwargs=kwargs):
                status, calls = self.invoke(**kwargs)
                self.assertEqual(status, 1)
                self.assertEqual(self.applies(calls), [])

    def test_bad_later_finding_posts_nothing(self):
        self.findings.write_text(json.dumps([finding(), finding(file="outside.py")]))
        status, calls = self.invoke()
        self.assertEqual(status, 1)
        self.assertEqual(self.applies(calls), [])

    def test_overwritten_patch_is_rejected_even_when_checkout_matches(self):
        self.diff.write_text("changed")
        status, calls = self.invoke(changed=True)
        self.assertEqual(status, 1)
        self.assertEqual(self.applies(calls), [])

    def test_change_before_batch_posts_nothing(self):
        self.findings.write_text(json.dumps([finding(), finding(file="gone.py", side="old", code="deleted()")]))
        status, calls = self.invoke(snapshot_results=[DIFF, "changed"])
        self.assertEqual(status, 1)
        self.assertEqual(self.applies(calls), [])

    def test_multiple_valid_findings_use_one_atomic_batch(self):
        self.findings.write_text(json.dumps([finding(), finding(file="gone.py", side="old", code="deleted()")]))
        status, calls = self.invoke()
        applies = self.applies(calls)
        self.assertEqual(status, 0)
        self.assertEqual(len(applies), 1)
        self.assertEqual(len(json.loads(applies[0][1]["input_text"])["comments"]), 2)


class LauncherTest(unittest.TestCase):
    def invoke(self, mode="local", reused=False, dirty=False, stale=False, changing=False):
        calls = []
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)

        def herdr(*args):
            calls.append(args)
            if args[:2] == ("agent", "get"):
                return {"agent": {"agent": "opencode", "workspace_id": "w-caller"}}
            if args[:2] == ("tab", "create"):
                return {"root_pane": {"pane_id": "w:p-new"}, "tab": {"tab_id": "w:t-new"}}
            if args[:2] == ("pane", "get"):
                return {"pane": {"tab_id": "w:t-root"}}
            if args[:2] == ("pane", "split"):
                return {"pane": {"pane_id": "w:p-agent"}}
            return {}

        def run(*args, **kwargs):
            calls.append(args)
            if args[:3] == ("git", "rev-parse", "--show-toplevel"):
                return "/repo with spaces\n"
            if args[0] == "git" and args[1] == "rev-parse":
                return "stale\n" if stale and args[2] == "HEAD" else "sha\n"
            if args[:2] == ("git", "status"):
                return " M file\n" if dirty else ""
            if args[:2] == ("hwt", "checkout"):
                return {"path": "/review checkout", "workspace_id": "w-review",
                        "pane_id": "w:p-root", "reused": reused, "identity": {"number": 7,
                        "url": "https://github.com/acme/app/pull/7"},
                        "review_command": {"status": "not_requested", "command": []}}
            raise AssertionError(args)

        argv = ["launch.py", mode] + (["acme/app#7"] if mode == "pr" else [])
        output = io.StringIO()
        with patch.object(sys, "argv", argv), \
                patch.dict(os.environ, {"HERDR_ENV": "1", "HERDR_PANE_ID": "w:p-caller"}), \
                patch.object(launch.shutil, "which", return_value="/binary"), \
                patch.object(launch, "herdr", side_effect=herdr), \
                patch.object(launch, "run", side_effect=run), \
                patch.object(launch, "snapshot", return_value=DIFF,
                             side_effect=[DIFF, "changed"] if changing else None), \
                patch.object(launch, "read_session", return_value=review_model()), \
                patch.object(launch, "is_shell", return_value=True), \
                patch.object(launch, "select_session", side_effect=lambda *args: (
                    calls.append(("select-session", *args)) or {"sessionId": "session-1"})), \
                patch.object(launch.tempfile, "mkdtemp", return_value=self.temp.name), \
                contextlib.redirect_stdout(output), contextlib.redirect_stderr(io.StringIO()):
            status = launch.main()
        return status, calls, output.getvalue()

    def test_local_current_workspace_and_80_20_layout(self):
        status, calls, output = self.invoke()
        self.assertEqual(status, 0)
        create = next(call for call in calls if call[:2] == ("tab", "create"))
        self.assertIn("w-caller", create)
        split = next(call for call in calls if call[:2] == ("pane", "split"))
        self.assertIn("0.8", split)
        self.assertIn("/repo with spaces", split)
        self.assertIn("--no-focus", split)
        viewer = next(call for call in calls if call[:2] == ("pane", "run"))
        self.assertIn("hunk patch", viewer[3])
        self.assertIn("--agent-notes", viewer[3])
        self.assertFalse(any(call[:2] == ("tab", "focus") for call in calls))
        prompt = next(call for call in calls if call[:2] == ("agent", "prompt"))
        self.assertNotIn("--wait", prompt)
        self.assertIn("add_findings.py", prompt[3])
        self.assertIn("explain-simply/SKILL.md", prompt[3])
        self.assertIn("EVERY", prompt[3])
        self.assertIn("Deploy safety and compatibility", prompt[3])
        self.assertIn("Maintainability", prompt[3])
        self.assertEqual(json.loads(output)["status"], "reviewing")

    def test_pr_uses_checkout_and_its_new_root_pane(self):
        status, calls, _ = self.invoke("pr")
        self.assertEqual(status, 0)
        hwt = next(call for call in calls if call[:2] == ("hwt", "checkout"))
        self.assertIn("https://github.com/acme/app/pull/7", hwt)
        self.assertIn("--reuse", hwt)
        self.assertFalse(any(call[:2] in [("hwt", "review"), ("tab", "create"), ("pane", "send-keys")]
                             for call in calls))
        viewer = next(call for call in calls if call[:2] == ("pane", "run"))
        self.assertEqual(viewer[2], "w:p-root")

    def test_reused_pr_worktree_gets_new_tab_without_touching_old_pane(self):
        status, calls, _ = self.invoke("pr", reused=True)
        self.assertEqual(status, 0)
        create = next(call for call in calls if call[:2] == ("tab", "create"))
        self.assertIn("w-review", create)
        viewer = next(call for call in calls if call[:2] == ("pane", "run"))
        self.assertEqual(viewer[2], "w:p-new")

    def test_dirty_or_stale_pr_refuses_to_start_viewer(self):
        for kwargs in [{"dirty": True}, {"stale": True}]:
            with self.subTest(kwargs=kwargs):
                status, calls, _ = self.invoke("pr", **kwargs)
                self.assertEqual(status, 1)
                self.assertFalse(any(call[:2] in [("pane", "run"), ("agent", "start")]
                                     for call in calls))

    def test_startup_change_does_not_start_reviewer(self):
        status, calls, _ = self.invoke(changing=True)
        self.assertEqual(status, 1)
        self.assertFalse(any(call[:2] == ("agent", "start") for call in calls))

    def test_session_selection_uses_unique_patch_not_repo_or_focus(self):
        rows = {"sessions": [{"sessionId": "other", "sourceLabel": "/other.patch", "inputKind": "patch"},
                             {"sessionId": "right", "sourceLabel": "/diff.patch", "inputKind": "patch"}]}
        with patch.object(launch, "run", return_value=rows):
            self.assertEqual(launch.select_session("/diff.patch")["sessionId"], "right")


class SnapshotTest(unittest.TestCase):
    def test_bounded_output_rejects_large_command_without_full_capture(self):
        with self.assertRaisesRegex(ValueError, "exceeds 4 MiB"):
            common.run(sys.executable, "-c", "import sys; sys.stdout.write('x' * 100000)", max_output_bytes=64)

    def test_bounded_output_preserves_source_characters(self):
        value = common.run(sys.executable, "-c", "import sys; sys.stdout.buffer.write(b'a\\r\\nb')", max_output_bytes=64)
        self.assertEqual(value, "a\r\nb")

    def test_revisions_resolve_to_immutable_commits(self):
        with patch.object(common, "run", side_effect=["base\n", "head\n"]) as run:
            self.assertEqual(common.resolve_revisions("/repo", "main...HEAD"), "base...head")
            self.assertIn("--end-of-options", run.call_args.args)

    def test_single_revision_reviews_commit_not_worktree(self):
        with patch.object(common, "run", return_value=DIFF) as run:
            self.assertEqual(common.snapshot("/repo", "sha"), DIFF)
            self.assertEqual(run.call_args.args[:2], ("git", "show"))
            self.assertIn("--diff-merges=first-parent", run.call_args.args)

    def test_live_session_must_still_show_same_patch(self):
        with patch.object(common, "run", return_value={"review": review_model("/other.patch")}):
            with self.assertRaisesRegex(ValueError, "no longer shows"):
                common.read_session({"session": "session-1", "diff": "/diff.patch"})

    def test_review_digest_ignores_focus_but_detects_patch_changes(self):
        review = review_model()
        self.assertEqual(common.review_digest(review), common.review_digest(review | {"selectedHunk": 9}))
        self.assertNotEqual(common.review_digest(review), common.review_digest(review | {"files": []}))

    def test_successful_herdr_write_can_have_empty_output(self):
        with patch.object(common, "run", return_value=""):
            self.assertEqual(common.herdr("pane", "run", "w:p1", "hunk"), {})

    def test_untracked_paths_preserve_spaces_and_allow_diff_exit_one(self):
        with patch.object(common, "run", side_effect=["tracked diff", "file with spaces\0", "new diff"]) as run:
            self.assertEqual(common.snapshot("/repo"), "tracked diffnew diff")
            args, kwargs = run.call_args
            self.assertEqual(args[-1], "file with spaces")
            self.assertEqual(kwargs["allowed"], (0, 1))


if __name__ == "__main__":
    unittest.main()
