#!/usr/bin/env python3
"""Check that inline command hook installation preserves other settings."""

import json
import os
import subprocess
import tempfile
import unittest
from pathlib import Path


INSTALLER = Path(__file__).resolve().parents[1] / "config/inline-command/install.sh"


class InstallTest(unittest.TestCase):
    def test_merge_is_idempotent_and_preserves_other_hooks(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            original = {
                "theme": "example",
                "env": {"CLAUDE_CODE_PLUGIN_DIRS": "/existing/plugin"},
                "hooks": {
                    "Stop": [{"hooks": [{"command": "printf stop"}, {"command": "workmux set-window-status done"}]}],
                    "Notification": [{"hooks": [{"command": "workmux set-window-status waiting"}]}],
                    "UserPromptSubmit": [{"matcher": "*", "hooks": [
                        {"command": "printf existing"},
                        {"command": "bun old/inline-command/hook.ts"},
                    ]}],
                },
            }
            paths = [home / ".claude/settings.json", home / ".codex/hooks.json"]
            for path in paths:
                path.parent.mkdir(parents=True)
                path.write_text(json.dumps(original))
            for _ in range(2):
                subprocess.run(["sh", str(INSTALLER)], env={**os.environ, "HOME": directory}, check=True)
            for path in paths:
                installed = json.loads(path.read_text())
                self.assertEqual(installed["theme"], original["theme"])
                self.assertEqual(installed["hooks"]["Stop"], [{"hooks": [{"command": "printf stop"}]}])
                self.assertNotIn("Notification", installed["hooks"])
                groups = installed["hooks"]["UserPromptSubmit"]
                self.assertEqual(len(groups), 2)
                self.assertEqual(groups[0], {"matcher": "*", "hooks": [{"command": "printf existing"}]})
                self.assertIn("inline-command/hook.ts", groups[1]["hooks"][0]["command"])
            plugins = json.loads(paths[0].read_text())["env"]["CLAUDE_CODE_PLUGIN_DIRS"].split(":")
            self.assertEqual(len(plugins), 2)
            self.assertIn("/existing/plugin", plugins)


if __name__ == "__main__":
    unittest.main()
