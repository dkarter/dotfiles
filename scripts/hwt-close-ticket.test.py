#!/usr/bin/env python3
"""Test ticket cleanup with fake CLIs; never contact Linear or remove a worktree."""

import json
import os
import pty
import select
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


HOOK = Path(__file__).resolve().parents[1] / "config/hwt/close-ticket.sh"


class CloseTicketTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.bin = self.root / "bin"
        self.bin.mkdir()
        (self.bin / "jq").symlink_to(shutil.which("jq"))
        self.log = self.root / "calls.jsonl"
        self.git_log = self.root / "git-called"
        self.env = {
            "HOME": str(self.root),
            "PATH": f"{self.bin}:/usr/bin:/bin",
            "HWT_TICKET_IDENTIFIER": "PLT-123",
            "TEST_LOG": str(self.log),
            "TEST_GIT_LOG": str(self.git_log),
            "TEST_REMOTE": "git@github.com:pdq/houston.git",
            "TEST_ISSUE": json.dumps({"issueId": "PLT-123", "status": {"type": "started"}}),
        }
        self.stub("git", """
import os
from pathlib import Path
Path(os.environ['TEST_GIT_LOG']).touch()
print(os.environ['TEST_REMOTE'])
""")
        self.stub("lnr", """
import json, os, sys
with open(os.environ['TEST_LOG'], 'a') as log:
    log.write(json.dumps(sys.argv[1:]) + '\\n')
if sys.argv[2] == 'get':
    print(os.environ['TEST_ISSUE'])
    sys.exit(int(os.environ.get('TEST_GET_EXIT', '0')))
sys.exit(int(os.environ.get('TEST_UPDATE_EXIT', '0')))
""")

    def stub(self, name, body):
        path = self.bin / name
        path.write_text(f"#!{shutil.which('python3')}\n{body}\n")
        path.chmod(0o755)

    def calls(self):
        if not self.log.exists():
            return []
        return [json.loads(line) for line in self.log.read_text().splitlines()]

    def run_hook(self, answer="n\n", interactive=True, **env):
        if not interactive:
            result = subprocess.run(
                ["sh", str(HOOK)], env=self.env | env, input=answer,
                capture_output=True, text=True, timeout=10,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            return result.stderr
        master, slave = pty.openpty()
        try:
            # Terminal stdin/stderr match HWT's synchronous hook wiring.
            with subprocess.Popen(
                ["sh", str(HOOK)], env=self.env | env,
                stdin=slave, stdout=subprocess.PIPE, stderr=slave,
            ) as process:
                os.write(master, answer.encode())
                try:
                    process.communicate(timeout=10)
                except subprocess.TimeoutExpired:
                    process.kill()
                    process.communicate()
                    raise
                self.assertEqual(process.returncode, 0)
            output = bytearray()
            # Drain before closing the last slave FD: macOS can discard unread
            # terminal output when that FD closes.
            while select.select([master], [], [], 0.1)[0]:
                try:
                    chunk = os.read(master, 4096)
                except OSError:
                    break
                if not chunk:
                    break
                output.extend(chunk)
            return output.decode()
        finally:
            if slave is not None:
                os.close(slave)
            os.close(master)

    def test_no_ticket_does_not_run_any_cli(self):
        self.run_hook(HWT_TICKET_IDENTIFIER="")
        self.assertFalse(self.git_log.exists())
        self.assertEqual(self.calls(), [])

    def test_noninteractive_skips_lookup(self):
        self.run_hook(interactive=False)
        self.assertEqual(self.calls(), [])

    def test_personal_repository_skips_lookup(self):
        self.run_hook(TEST_REMOTE="git@github.com:dkarter/lnr.git")
        self.assertEqual(self.calls(), [])

    def test_spoofed_remote_skips_lookup(self):
        self.run_hook(TEST_REMOTE="https://github.com/pdq-other/houston.git")
        self.assertEqual(self.calls(), [])

    def test_missing_lnr_skips_lookup(self):
        (self.bin / "lnr").unlink()
        output = self.run_hook()
        self.assertNotIn("Mark", output)
        self.assertEqual(self.calls(), [])

    def test_closed_ticket_does_not_prompt(self):
        for state in ("completed", "canceled"):
            with self.subTest(state=state):
                output = self.run_hook(TEST_ISSUE=json.dumps({"issueId": "PLT-123", "status": {"type": state}}))
                self.assertNotIn("Mark", output)
        self.assertTrue(all(call == ["issue", "get", "PLT-123", "--json"] for call in self.calls()))

    def test_declining_or_enter_does_not_update(self):
        for answer in ("n\n", "\n"):
            with self.subTest(answer=answer):
                self.assertIn("[y/N]", self.run_hook(answer))
        self.assertEqual(len(self.calls()), 2)
        self.assertTrue(all(call[1] == "get" for call in self.calls()))

    def test_confirming_updates_only_the_assigned_ticket(self):
        self.run_hook("y\n")
        self.assertEqual(self.calls(), [
            ["issue", "get", "PLT-123", "--json"],
            ["issue", "update", "PLT-123", "--status", "Done", "--json"],
        ])

    def test_lookup_failure_does_not_block_or_prompt(self):
        output = self.run_hook(TEST_GET_EXIT="1")
        self.assertIn("continuing worktree removal", output)
        self.assertNotIn("Mark", output)
        self.assertEqual(len(self.calls()), 1)

    def test_invalid_output_does_not_prompt(self):
        for data in ("not json", '{}', '{"issueId":"OTHER-1","status":{"type":"started"}}', '{"issueId":"PLT-123","status":{"type":"unknown"}}'):
            with self.subTest(data=data):
                self.assertNotIn("Mark", self.run_hook(TEST_ISSUE=data))
        self.assertTrue(all(call[1] == "get" for call in self.calls()))

    def test_update_failure_does_not_block_removal(self):
        output = self.run_hook("yes\n", TEST_UPDATE_EXIT="1")
        self.assertIn("could not mark ticket as Done", output)
        self.assertEqual(len(self.calls()), 2)


if __name__ == "__main__":
    unittest.main()
