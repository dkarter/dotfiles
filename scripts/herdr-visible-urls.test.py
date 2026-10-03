#!/usr/bin/env python3
"""Regression tests for visible URL pane subtitles."""

import runpy
import unittest
from pathlib import Path


VISIBLE_URLS = runpy.run_path(str(Path(__file__).resolve().parents[1] / "bin/herdr-visible-urls"))
PANE_TITLE = VISIBLE_URLS["pane_title"]
EXTRACT_URLS = VISIBLE_URLS["extract_urls"]


class VisibleUrlsTest(unittest.TestCase):
    def test_pane_title_falls_back_to_terminal(self):
        self.assertEqual(PANE_TITLE({"pane_id": "w1:p1"}), "󰆍 terminal")
        self.assertEqual(PANE_TITLE({"pane_id": "w1:p1", "label": "Browser"}), "Browser")
        self.assertEqual(PANE_TITLE({"label": " opencode", "display_agent": " opencode", "agent": "opencode"}), " opencode")

    def test_next_line_number_is_not_url_continuation(self):
        text = (
            "134  # docs: https://mise.jdx.dev/dev-tools/aliases.html\n"
            "135  # list of plugins https://mise.jdx.dev/registry.html\n"
            "136  [tool_alias]\n"
        )
        self.assertEqual(
            EXTRACT_URLS(text, 58),
            ["https://mise.jdx.dev/dev-tools/aliases.html", "https://mise.jdx.dev/registry.html"],
        )

    def test_wrapped_url_still_joins(self):
        self.assertEqual(
            EXTRACT_URLS("https://mise.jdx.dev/dev-tools/\n  aliases.html", 32),
            ["https://mise.jdx.dev/dev-tools/aliases.html"],
        )

    def test_literal_escaped_newline_is_not_part_of_url(self):
        self.assertEqual(
            EXTRACT_URLS(r"https://mise.jdx.dev/registry.html\n", 80),
            ["https://mise.jdx.dev/registry.html"],
        )


if __name__ == "__main__":
    unittest.main()
