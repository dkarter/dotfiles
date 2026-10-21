#!/usr/bin/env python3
"""Check review command arguments without opening real tabs."""

import json
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


COMMAND = Path(__file__).resolve().parents[1] / "config/herdr/plugins/command-palette/commands/review-changes"


class ReviewCommandTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.repo = self.root / "repo with 'quotes'"
        (self.repo / "subdir").mkdir(parents=True)
        self.log = self.root / "calls.jsonl"
        self.env = {
            "HOME": str(self.root),
            "PATH": f"{self.bin}:/usr/bin:/bin",
            "TEST_LOG": str(self.log),
            "TEST_REPO": str(self.repo),
            "TEST_GIT_LOG": str(self.root / "git.jsonl"),
            "HERDR_PLUGIN_CONTEXT_JSON": json.dumps({
                "workspace_id": "w-test",
                "focused_pane": {"foreground_cwd": str(self.repo / "subdir")},
            }),
        }
        (self.bin / "jq").symlink_to(shutil.which("jq"))
        self.stub("git", """
import json, os, sys
repo = os.environ['TEST_REPO']
assert sys.argv[1:3] in (['-C', repo + '/subdir'], ['-C', repo])
with open(os.environ['TEST_GIT_LOG'], 'a') as f: f.write(json.dumps(sys.argv[1:]) + '\\n')
if 'rev-parse' in sys.argv and '--show-toplevel' in sys.argv:
    if os.environ.get('TEST_NO_REPO'): sys.exit(1)
    print(repo)
elif 'merge-base' in sys.argv: print('abc123')
elif os.environ.get('TEST_NO_MAIN'): sys.exit(1)
""")
        self.stub("gh", """
import os, sys
assert sys.argv[1:] == ['pr', 'view', '--json', 'baseRefName', '--jq', '.baseRefName']
if not os.environ.get('TEST_PR_BASE'): sys.exit(1)
print(os.environ['TEST_PR_BASE'])
""")
        self.stub("herdr", """
import json, os, sys
with open(os.environ['TEST_LOG'], 'a') as f: f.write(json.dumps(sys.argv[1:]) + '\\n')
if sys.argv[1:3] == ['tab', 'create']:
    print(json.dumps({'result': {'tab': {'tab_id': 'new-tab'}, 'root_pane': {'pane_id': 'new-pane'}}}))
""")
        self.stub("gum", "import os; print(os.environ.get('TEST_CHOICE', ''))")
        for viewer in ("tuicr", "hunk", "nvim"):
            self.stub(viewer, "pass")

    def stub(self, name, body):
        path = self.bin / name
        path.write_text(f"#!{shutil.which('python3')}\n{body}\n")
        path.chmod(0o755)

    def run_command(self, *args, **env):
        return subprocess.run(
            [shutil.which("zsh"), str(COMMAND), *args],
            env=self.env | env, capture_output=True, text=True, timeout=10,
        )

    def test_all_viewers_and_scopes(self):
        for scope, viewer, expected in (
            ("working-tree", "tuicr", ["tuicr", "--no-update-check", "--working-tree"]),
            ("branch", "tuicr", ["tuicr", "--no-update-check", "-r", "abc123..HEAD", "--working-tree"]),
            ("working-tree", "hunk", ["hunk", "diff"]),
            ("branch", "hunk", ["hunk", "diff", "abc123"]),
            ("working-tree", "codediff", ["nvim", "+CodeDiff"]),
            ("branch", "codediff", ["nvim", "+CodeDiff abc123"]),
        ):
            with self.subTest(scope=scope, viewer=viewer):
                self.log.write_text("")
                result = self.run_command(scope, viewer)
                self.assertEqual(result.returncode, 0, result.stderr)
                calls = [json.loads(line) for line in self.log.read_text().splitlines()]
                self.assertIn(str(self.repo), calls[0])
                self.assertIn("w-test", calls[0])
                self.assertEqual(calls[1][:3], ["pane", "run", "new-pane"])
                # Decode exactly as the target zsh would, including spaced Ex commands.
                decoded = subprocess.check_output(
                    [shutil.which("zsh"), "-c", f"printf '%s\\0' {calls[1][3]}"],
                ).decode().rstrip("\0").split("\0")
                self.assertEqual(decoded, expected)
                self.assertEqual(calls[2], ["tab", "focus", "new-tab"])

    def test_cancel_and_errors_do_not_create_tabs(self):
        for args, env, code in (
            ([], {}, 0),
            (["working-tree"], {}, 0),
            (["working-tree", "hunk"], {"TEST_NO_REPO": "1"}, 1),
            (["branch", "hunk"], {"TEST_NO_MAIN": "1"}, 1),
            (["invalid", "hunk"], {}, 1),
            (["working-tree", "invalid"], {}, 1),
        ):
            with self.subTest(args=args, env=env):
                result = self.run_command(*args, **env)
                self.assertEqual(result.returncode, code, result.stderr)
                self.assertFalse(self.log.exists())

    def test_flat_plugin_cwd_context(self):
        result = self.run_command(
            "working-tree", "hunk",
            HERDR_PLUGIN_CONTEXT_JSON=json.dumps({
                "workspace_id": "w-test", "focused_pane_cwd": str(self.repo / "subdir"),
            }),
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        calls = [json.loads(line) for line in self.log.read_text().splitlines()]
        self.assertIn(str(self.repo), calls[0])

    def test_branch_base_is_pr_target_or_main(self):
        for pr_base, expected in (("feature/parent", "feature/parent"), ("", "main")):
            with self.subTest(pr_base=pr_base):
                git_log = Path(self.env["TEST_GIT_LOG"])
                git_log.write_text("")
                result = self.run_command("branch", "hunk", TEST_PR_BASE=pr_base)
                self.assertEqual(result.returncode, 0, result.stderr)
                calls = [json.loads(line) for line in git_log.read_text().splitlines()]
                merge_base = next(call for call in calls if "merge-base" in call)
                self.assertEqual(merge_base[-2:], [f"refs/remotes/origin/{expected}", "HEAD"])


if __name__ == "__main__":
    unittest.main()
