#!/usr/bin/env python3
"""Test command-palette HWT delegation without creating or removing worktrees."""

import json
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


COMMANDS = Path(__file__).resolve().parents[1] / "config/herdr/plugins/command-palette/commands"


class WorktreeCommandsTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.bin = self.root / "bin"
        self.bin.mkdir()
        (self.bin / "jq").symlink_to(shutil.which("jq"))
        self.log = self.root / "hwt.json"
        self.env = {
            "HOME": str(self.root),
            "PATH": f"{self.bin}:/usr/bin:/bin",
            "HERDR_PLUGIN_CONTEXT_JSON": json.dumps({
                "workspace_id": "w1",
                "focused_pane_cwd": "/repo with spaces",
            }),
            "TEST_LOG": str(self.log),
        }
        self.zsh = shutil.which("zsh")
        self.stub("hwt", """
import json, os, sys
from pathlib import Path
Path(os.environ["TEST_LOG"]).write_text(json.dumps({
    "args": sys.argv[1:],
    "context": json.loads(os.environ["HERDR_PLUGIN_CONTEXT_JSON"]),
}))
sys.exit(int(os.environ.get("TEST_HWT_EXIT", "0")))
""")
        self.stub("ink", 'import os; print(os.environ.get("TEST_INPUT", ""))')
        for name in ("gum", "tv", "nvim"):
            self.stub(name, "pass")

    def stub(self, name, body):
        path = self.bin / name
        path.write_text(f"#!{shutil.which('python3')}\n{body}\n")
        path.chmod(0o755)

    def run_command(self, name, **env):
        return subprocess.run(
            [self.zsh, str(COMMANDS / name)],
            env=self.env | env,
            capture_output=True,
            text=True,
            timeout=10,
        )

    def test_checkout_converts_graphite_and_preserves_other_selectors(self):
        for selector, expected in (
            ("https://app.graphite.com/github/pr/acme/app/42", "https://github.com/acme/app/pull/42"),
            ("https://app.graphite.com/github/pr/acme/app/42?view=activity#comments", "https://github.com/acme/app/pull/42"),
            ("https://github.com/acme/app/pull/42", "https://github.com/acme/app/pull/42"),
            ("feature/my-branch", "feature/my-branch"),
            ("42", "42"),
            ("--help", "--help"),
        ):
            with self.subTest(selector=selector):
                result = self.run_command("checkout-worktree", TEST_INPUT=selector)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(
                    json.loads(self.log.read_text())["args"],
                    ["checkout", "--cwd", "/repo with spaces", "--focus", "--", expected],
                )

    def test_checkout_cancellation_does_not_call_hwt(self):
        result = self.run_command("checkout-worktree", TEST_INPUT="")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(self.log.exists())

    def test_checkout_falls_back_to_active_pane_cwd(self):
        result = self.run_command(
            "checkout-worktree",
            TEST_INPUT="feature/test",
            HERDR_PLUGIN_CONTEXT_JSON="{}",
            HERDR_ACTIVE_PANE_CWD="/active repo",
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            json.loads(self.log.read_text())["args"],
            ["checkout", "--cwd", "/active repo", "--focus", "--", "feature/test"],
        )

    def test_checkout_propagates_hwt_failure(self):
        result = self.run_command("checkout-worktree", TEST_INPUT="feature/test", TEST_HWT_EXIT="7")
        self.assertEqual(result.returncode, 7, result.stderr)

    def test_remove_delegates_with_original_plugin_context(self):
        result = self.run_command("delete-current-worktree")
        self.assertEqual(result.returncode, 0, result.stderr)
        invocation = json.loads(self.log.read_text())
        self.assertEqual(invocation["args"], ["herdr", "remove"])
        self.assertEqual(invocation["context"]["workspace_id"], "w1")

    def test_remove_propagates_hwt_failure(self):
        result = self.run_command("delete-current-worktree", TEST_HWT_EXIT="7")
        self.assertEqual(result.returncode, 7, result.stderr)


if __name__ == "__main__":
    unittest.main()
