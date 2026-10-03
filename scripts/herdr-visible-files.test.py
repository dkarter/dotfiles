#!/usr/bin/env python3
"""Regression tests for visible file references in Herdr panes."""

import io
import json
import os
import runpy
import shlex
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch


VISIBLE_FILES = runpy.run_path(str(Path(__file__).resolve().parents[1] / "bin/herdr-visible-files"))
PATHS_IN = VISIBLE_FILES["paths_in"]
PANE_TITLE = VISIBLE_FILES["pane_title"]
OPENER = runpy.run_path(str(Path(__file__).resolve().parents[1] / "bin/herdr-open-visible-file"))


class VisibleFilesTest(unittest.TestCase):
    def test_pane_title_falls_back_to_terminal(self):
        self.assertEqual(PANE_TITLE({"pane_id": "w1:p1"}), "󰆍 terminal")
        self.assertEqual(PANE_TITLE({"pane_id": "w1:p1", "label": "Editor"}), "Editor")
        self.assertEqual(PANE_TITLE({"label": " opencode", "display_agent": " opencode", "agent": "opencode"}), " opencode")

    def test_line_references_without_directory(self):
        with tempfile.TemporaryDirectory() as cwd:
            path = Path(cwd) / "file.tf"
            path.touch()
            self.assertEqual(
                list(PATHS_IN("file.tf:12\nfile.tf:200", cwd, 80)),
                [(str(path), "file.tf:12"), (str(path), "file.tf:200")],
            )

    def test_distinct_line_references_appear_as_separate_entries(self):
        with tempfile.TemporaryDirectory() as cwd:
            path = Path(cwd) / "some_folder/another_folder/file.tf"
            path.parent.mkdir(parents=True)
            path.touch()
            reference = str(path.relative_to(cwd))
            text = f"{reference}:12\n{reference}:200\n{reference}:12\n{reference}"

            def herdr(*args):
                if args[:2] == ("pane", "layout"):
                    return json.dumps({"result": {"layout": {
                        "workspace_id": "workspace", "zoomed": False,
                        "panes": [{"pane_id": "pane", "focused": True, "rect": {"width": 100}}],
                    }}})
                if args[:2] == ("pane", "list"):
                    return json.dumps({"result": {"panes": [{"pane_id": "pane", "cwd": cwd, "label": "terminal"}]}})
                return text

            output = io.StringIO()
            with patch.dict(VISIBLE_FILES["main"].__globals__, {"herdr": herdr}), patch.dict(os.environ, {"HERDR_ACTIVE_PANE_ID": "pane"}), patch("sys.stdout", output):
                VISIBLE_FILES["main"]()
            entries = json.loads(output.getvalue())
            self.assertEqual([entry["display_path"] for entry in entries], [f"{reference}:12", f"{reference}:200", reference])
            self.assertEqual([entry["path"] for entry in entries], [str(path)] * 3)
            self.assertEqual([entry["reference"] for entry in entries], [f"{path}:12", f"{path}:200", str(path)])

    def test_line_references(self):
        with tempfile.TemporaryDirectory() as cwd:
            path = Path(cwd) / "lib/connect/sharding/actions/get_sharding_readiness.ex"
            path.parent.mkdir(parents=True)
            path.touch()
            for reference in (
                f"{path.relative_to(cwd)}:191–203",
                f"{path.relative_to(cwd)}:191-203",
                f"{path.relative_to(cwd)}:191:4",
            ):
                with self.subTest(reference=reference):
                    self.assertIn((str(path), reference), list(PATHS_IN(f"({reference})", cwd, 100)))

    def test_wrapped_path_and_range(self):
        with tempfile.TemporaryDirectory() as cwd:
            path = Path(cwd) / "lib/connect/sharding/actions/get_sharding_readiness.ex"
            path.parent.mkdir(parents=True)
            path.touch()
            reference = f"{path.relative_to(cwd)}:191–203"
            for text, width in (
                ("lib/connect/sharding/\n  actions/get_sharding_readiness.ex:191–203", 24),
                ("lib/connect/sharding/actions/get_sharding_readiness.ex\n  :191–203", 57),
                ("lib/connect/sharding/\n  actions/get_sharding_readiness.ex:\n  191–203", 40),
            ):
                with self.subTest(text=text):
                    matches = [display for found, display in PATHS_IN(text, cwd, width) if found == str(path)]
                    self.assertEqual(matches[0], reference)

    def test_open_at_line_or_select_range(self):
        command = OPENER["location_command"]
        self.assertEqual(command("lib/example.ex:191"), "normal! 191G")
        self.assertEqual(command("lib/example.ex:191:4"), "normal! 191G")
        self.assertEqual(command("lib/example.ex:191–203"), "normal! 191GV203G")
        self.assertEqual(command("lib/example.ex:191-203"), "normal! 191GV203G")
        self.assertIsNone(command("lib/example.ex"))

    def test_new_pane_opens_at_range(self):
        with tempfile.TemporaryDirectory() as cwd:
            path = Path(cwd) / "example.ex"
            path.touch()
            calls = []

            def herdr(*args):
                calls.append(args)
                if args[:2] == ("pane", "layout"):
                    return json.dumps({"result": {"layout": {"panes": []}}})
                return json.dumps({"result": {"pane": {"pane_id": "new"}}})

            with patch.dict(OPENER["main"].__globals__, {"herdr": herdr}), patch.dict(os.environ, {"HERDR_ACTIVE_PANE_ID": "active"}), patch("sys.argv", ["herdr-open-visible-file", str(path), "example.ex:191–203"]):
                OPENER["main"]()
            self.assertEqual(shlex.split(calls[-1][3]), ["nvim", "+normal! 191GV203G", "--", str(path)])

    def test_existing_pane_selects_range(self):
        with tempfile.TemporaryDirectory() as cwd:
            path = Path(cwd) / "example.ex"
            path.touch()
            calls = []

            def herdr(*args):
                calls.append(args)
                if args[:2] == ("pane", "layout"):
                    return json.dumps({"result": {"layout": {"panes": [{"pane_id": "editor", "focused": True}]}}})
                return json.dumps({"result": {"process_info": {"foreground_processes": [{"name": "nvim"}]}}})

            with patch.dict(OPENER["main"].__globals__, {"herdr": herdr}), patch.dict(os.environ, {"HERDR_ACTIVE_PANE_ID": "active"}), patch("sys.argv", ["herdr-open-visible-file", str(path), "example.ex:191–203"]):
                OPENER["main"]()
            self.assertEqual(calls[-2], ("pane", "send-text", "editor", "execute 'edit ' . fnameescape('" + str(path) + "') | normal! 191GV203G"))


if __name__ == "__main__":
    unittest.main()
