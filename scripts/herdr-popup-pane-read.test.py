#!/usr/bin/env python3
"""Regression tests for the Herdr pane picker source."""

import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


PICKER = Path(__file__).resolve().parents[1] / "bin/herdr-popup-pane-read"


class PanePickerTest(unittest.TestCase):
    def test_paste_wraps_command_without_executing_it(self):
        with tempfile.TemporaryDirectory() as directory:
            herdr = Path(directory) / "herdr"
            herdr.write_text(
                '#!/usr/bin/env python3\n'
                'import json, sys\n'
                'print(json.dumps(sys.argv[1:]))\n'
            )
            herdr.chmod(0o755)
            result = subprocess.run(
                ["bash", str(PICKER), "--paste", "w1:p2"],
                env={**os.environ, "HERDR_BIN_PATH": str(herdr), "HERDR_ACTIVE_PANE_ID": "w1:p1"},
                text=True, capture_output=True, check=True,
            )
        self.assertEqual(json.loads(result.stdout), [
            "pane", "send-text", "w1:p1",
            "!`herdr pane read w1:p2 --source recent-unwrapped --lines 160`",
        ])

    def test_titles_and_current_tab_filter(self):
        panes = [
            {"pane_id": "w1:p1", "label": "", "agent": None, "terminal_title_stripped": ""},
            {"pane_id": "w1:p2", "label": " neovim", "agent": None},
            {"pane_id": "w1:p3", "label": "", "agent": "opencode", "terminal_title_stripped": "stale title"},
            {"pane_id": "w1:p4", "terminal_title_stripped": "server"},
            {"pane_id": "w1:p5"},
        ]
        for pane in panes:
            pane.update(tab_id="w1:t1", cwd="/project")
        panes.append({"pane_id": "w1:p6", "tab_id": "w1:t2", "cwd": "/other"})

        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "current.json").write_text(json.dumps({"result": {"pane": {
                "tab_id": "w1:t1", "workspace_id": "w1",
            }}}))
            (root / "panes.json").write_text(json.dumps({"result": {"panes": panes}}))
            herdr = root / "herdr"
            herdr.write_text(
                '#!/usr/bin/env bash\n'
                'case "$*" in\n'
                '  "pane current --pane w1:p1") cat "${0%/*}/current.json" ;;\n'
                '  "pane list --workspace w1") cat "${0%/*}/panes.json" ;;\n'
                '  *) exit 1 ;;\n'
                'esac\n'
            )
            herdr.chmod(0o755)
            result = subprocess.run(
                ["bash", str(PICKER), "--source"],
                env={**os.environ, "HERDR_BIN_PATH": str(herdr), "HERDR_ACTIVE_PANE_ID": "w1:p1"},
                text=True, capture_output=True, check=True,
            )

        entries = json.loads(result.stdout)
        self.assertEqual([entry["label"] for entry in entries], [
            "󰆍 terminal", " neovim", "opencode", "server", "󰆍 terminal",
        ])
        self.assertEqual(entries[0]["current_label"], "current")
        self.assertTrue(all(entry["current_label"] == "" for entry in entries[1:]))


if __name__ == "__main__":
    unittest.main()
