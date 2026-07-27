#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["fonttools==4.63.0"]
# ///

"""Build the checked-in JetBrains Mono Nerd Font with coding-agent glyphs."""

from __future__ import annotations

import argparse
import copy
import hashlib
import io
import json
import shutil
import tarfile
import tempfile
import urllib.request
import xml.etree.ElementTree as ET
from datetime import date, timedelta
from pathlib import Path

from fontTools.colorLib.builder import buildCOLR, buildCPAL
from fontTools.pens.boundsPen import BoundsPen
from fontTools.pens.cu2quPen import Cu2QuPen
from fontTools.pens.transformPen import TransformPen
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.svgLib.path import parse_path
from fontTools.ttLib import TTFont

ROOT = Path(__file__).resolve().parent.parent
OUTPUT_DIR = ROOT / "assets/fonts/AgentMonoNerdFont"
METADATA_PATH = OUTPUT_DIR / "metadata.json"
NERD_FONTS_RELEASE_API = (
    "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest"
)
LOBE_ICONS_COMMIT_API = (
    "https://api.github.com/repos/lobehub/lobe-icons/commits/master"
)
FONT_ARCHIVE_NAME = "JetBrainsMono.tar.xz"
FONT_STYLES = ("Regular", "Italic", "Bold", "BoldItalic")
FONTTOOLS_VERSION = "4.63.0"
CLAUDE_COLOR = (0xD7 / 255, 0x77 / 255, 0x57 / 255, 1.0)

# Keep these stable: pane-title strings persist independently of font updates.
ICONS = {
    "amp": (0xE100, "amp.svg"),
    "claude": (0xE101, "claudecode.svg"),
    "cline": (0xE102, "cline.svg"),
    "codex": (0xE103, "codex.svg"),
    "copilot": (0xE104, "copilot.svg"),
    "cursor": (0xE105, "cursor.svg"),
    "gemini": (0xE106, "geminicli.svg"),
    "grok": (0xE107, "grok.svg"),
    "hermes": (0xE108, "hermesagent.svg"),
    "kilo": (0xE109, "kilocode.svg"),
    "kimi": (0xE10A, "kimi.svg"),
    "mastracode": (0xE10B, "mastra.svg"),
    "opencode": (0xE10C, "opencode.svg"),
    "pi": (0xE10D, "pi.svg"),
    "qodercli": (0xE10E, "qoder.svg"),
}


def fetch(url: str) -> bytes:
    request = urllib.request.Request(url, headers={"User-Agent": "dotfiles-font-builder"})
    with urllib.request.urlopen(request) as response:
        return response.read()


def fetch_json(url: str) -> dict[str, object]:
    return json.loads(fetch(url))


def is_fresh() -> bool:
    if not METADATA_PATH.exists():
        return False
    metadata = json.loads(METADATA_PATH.read_text())
    updated_at = date.fromisoformat(metadata["updated_at"])
    return date.today() < updated_at + timedelta(days=30)


def svg_glyph(svg: bytes, advance_width: int, units_per_em: int):
    root = ET.fromstring(svg)
    paths = root.findall("{http://www.w3.org/2000/svg}path")
    if not paths:
        raise ValueError("SVG has no paths")

    bounds_pen = BoundsPen(None)
    for path in paths:
        parse_path(path.attrib["d"], bounds_pen)
    if bounds_pen.bounds is None:
        raise ValueError("SVG paths have no bounds")
    min_x, min_y, max_x, max_y = bounds_pen.bounds
    width = max_x - min_x
    height = max_y - min_y
    # Match Nerd Font's 720-unit icon height while keeping short, wide marks legible.
    scale = max(advance_width * 1.2 / max(width, height), advance_width / height)
    rendered_width = width * scale
    x_offset = max(0, (advance_width - rendered_width) / 2) - min_x * scale
    center_y = units_per_em * 0.36
    y_offset = center_y + (min_y + max_y) * scale / 2

    glyph_pen = TTGlyphPen(None)
    curve_pen = Cu2QuPen(glyph_pen, max_err=1.0, reverse_direction=False)
    pen = TransformPen(curve_pen, (scale, 0, 0, -scale, x_offset, y_offset))
    for path in paths:
        parse_path(path.attrib["d"], pen)
    return glyph_pen.glyph()


def rename_font(font: TTFont, style: str) -> None:
    style_name = "Bold Italic" if style == "BoldItalic" else style
    replacements = {
        "JetBrainsMono Nerd Font Mono": "Agent Mono Nerd Font",
        "JetBrainsMono NFM": "Agent Mono NF",
        "JetBrainsMonoNerdFontMono": "AgentMonoNerdFont",
        "JetBrainsMonoNFM": "AgentMonoNF",
    }
    for record in font["name"].names:
        try:
            value = record.toUnicode()
        except UnicodeDecodeError:
            continue
        updated = value
        for old, new in replacements.items():
            updated = updated.replace(old, new)
        if updated != value:
            record.string = updated.encode(record.getEncoding())

    family = "Agent Mono Nerd Font"
    postscript_family = "AgentMonoNerdFont"
    font["name"].setName(family, 16, 3, 1, 0x409)
    font["name"].setName(style_name, 17, 3, 1, 0x409)
    font["name"].setName(f"{family} {style_name}", 4, 3, 1, 0x409)
    font["name"].setName(f"{postscript_family}-{style}", 6, 3, 1, 0x409)


def patch_font(source: Path, destination: Path, style: str, svgs: dict[str, bytes]) -> None:
    font = TTFont(source, recalcTimestamp=False)
    unicode_tables = [table for table in font["cmap"].tables if table.isUnicode()]
    occupied = set().union(*(set(table.cmap) for table in unicode_tables))
    collisions = [f"U+{codepoint:04X}" for codepoint, _ in ICONS.values() if codepoint in occupied]
    if collisions:
        raise RuntimeError(f"Nerd Font now occupies custom codepoints: {', '.join(collisions)}")

    advance_width = font["hmtx"].metrics["space"][0]
    units_per_em = font["head"].unitsPerEm
    for name, (codepoint, _) in ICONS.items():
        glyph_name = f"agent.{name}"
        glyph = svg_glyph(svgs[name], advance_width, units_per_em)
        font["glyf"][glyph_name] = glyph
        glyph.recalcBounds(font["glyf"])
        font["hmtx"].metrics[glyph_name] = (advance_width, glyph.xMin)
        for table in unicode_tables:
            table.cmap[codepoint] = glyph_name

        if name == "claude":
            layer_name = f"{glyph_name}.color"
            font["glyf"][layer_name] = copy.deepcopy(glyph)
            font["hmtx"].metrics[layer_name] = (advance_width, glyph.xMin)

    font["COLR"] = buildCOLR(
        {"agent.claude": [("agent.claude.color", 0)]},
        version=0,
        glyphMap=font.getReverseGlyphMap(),
    )
    font["CPAL"] = buildCPAL([[CLAUDE_COLOR]])

    rename_font(font, style)
    font.save(destination, reorderTables=False)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--force", action="store_true", help="ignore the 30-day refresh limit")
    args = parser.parse_args()
    if not args.force and is_fresh():
        print("Agent font cache is less than 30 days old; nothing to update.")
        return

    release = fetch_json(NERD_FONTS_RELEASE_API)
    version = str(release["tag_name"])
    archive_url = next(
        str(asset["browser_download_url"])
        for asset in release["assets"]  # type: ignore[union-attr]
        if asset["name"] == FONT_ARCHIVE_NAME
    )
    lobe_commit = str(fetch_json(LOBE_ICONS_COMMIT_API)["sha"])
    archive = fetch(archive_url)
    archive_sha256 = hashlib.sha256(archive).hexdigest()

    svg_base_url = (
        "https://raw.githubusercontent.com/lobehub/lobe-icons/"
        f"{lobe_commit}/packages/static-svg/icons"
    )
    svgs = {
        name: fetch(f"{svg_base_url}/{filename}")
        for name, (_, filename) in ICONS.items()
    }

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="agent-font-") as temporary_directory:
        temporary = Path(temporary_directory)
        with tarfile.open(fileobj=io.BytesIO(archive), mode="r:xz") as tar:
            members = {member.name: member for member in tar.getmembers()}
            for style in FONT_STYLES:
                filename = f"JetBrainsMonoNerdFontMono-{style}.ttf"
                source_file = tar.extractfile(members[filename])
                if source_file is None:
                    raise RuntimeError(f"Font archive is missing {filename}")
                (temporary / filename).write_bytes(source_file.read())
            license_file = tar.extractfile(members["OFL.txt"])
            if license_file is None:
                raise RuntimeError("Font archive is missing OFL.txt")
            (OUTPUT_DIR / "OFL.txt").write_bytes(license_file.read())
        for style in FONT_STYLES:
            source = temporary / f"JetBrainsMonoNerdFontMono-{style}.ttf"
            destination = temporary / f"AgentMonoNerdFont-{style}.ttf"
            patch_font(source, destination, style, svgs)
            shutil.move(destination, OUTPUT_DIR / destination.name)

    metadata = {
        "updated_at": date.today().isoformat(),
        "nerd_fonts_version": version,
        "nerd_fonts_archive_sha256": archive_sha256,
        "lobe_icons_commit": lobe_commit,
        "fonttools_version": FONTTOOLS_VERSION,
        "colors": {"claude": "#D77757"},
        "glyphs": {
            name: {"codepoint": f"U+{codepoint:04X}", "source": filename}
            for name, (codepoint, filename) in ICONS.items()
        },
    }
    METADATA_PATH.write_text(json.dumps(metadata, indent=2) + "\n")
    print(f"Updated {len(FONT_STYLES)} font faces from Nerd Fonts {version}.")


if __name__ == "__main__":
    main()
