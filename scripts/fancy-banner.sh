#!/usr/bin/env bash
# Dotfiles splash screen animation — purple/magenta theme
#
# Speed control: set BANNER_SPEED before calling, or pass as first argument.
#   1.0  = default
#   0.5  = 2× faster
#   0.0  = instant (no animation delays)
# Example: BANNER_SPEED=0.5 bash scripts/banner.sh

# ── Colors ────────────────────────────────────────────────────────────────────
RESET="\033[0m"

C_MID="\033[38;5;177m"   # mid lavender
C_DIM_P="\033[38;5;141m" # muted purple
C_DARK="\033[38;5;97m"   # dark purple
C_GREY="\033[38;5;240m"  # dim grey
C_TEAL="\033[38;5;87m"   # accent teal

# ── Speed ─────────────────────────────────────────────────────────────────────
BANNER_SPEED="${1:-${BANNER_SPEED:-1.0}}"

# Scaled sleep using awk for float math — no python needed
delay() {
  local secs
  secs=$(awk "BEGIN { d = $1 * ${BANNER_SPEED}; if (d > 0) printf \"%.4f\", d }")
  [[ -n $secs ]] && sleep "$secs"
}

# ── Helpers ───────────────────────────────────────────────────────────────────
hide_cursor() { tput civis 2>/dev/null; }
show_cursor() { tput cnorm 2>/dev/null; }
clear_screen() { tput clear 2>/dev/null || printf '\033[2J\033[H'; }
move() { tput cup "$1" "$2" 2>/dev/null; }
clear_line() { printf '\033[K'; }

trap 'show_cursor; printf "%b" "${RESET}"; echo' EXIT INT TERM

# ── Data ──────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION=$(cat "${SCRIPT_DIR}/../version.txt" 2>/dev/null || echo "?.?.?")

banner_lines=(
  "▓█▀▄ █▀█ █▀█ █ ▄▀█ █▄ █ ▀ █▀"
  "▒█▄▀ █▄█ █▀▄ █ █▀█ █ ▀█   ▄█"
  ""
  "▓█▀▄ █▀█ ▀█▀ █▀▀ █ █   █▀▀ █▀"
  "▒█▄▀ █▄█  █  █▀  █ █▄▌ ██▄ ▄█"
)

tools=(
  "neovim" "zsh" "tmux" "ghostty" "mise" "starship" "tv"
)

subtitle="a developer's home away from home"

# ── Geometry ──────────────────────────────────────────────────────────────────
TERM_W=$(tput cols 2>/dev/null || echo 80)
BANNER_W=30

pad_left=$(((TERM_W - BANNER_W) / 2))
[[ $pad_left -lt 0 ]] && pad_left=0
INDENT=$(printf '%*s' "$pad_left" '')

# ── Phase 1: fade each banner line in ────────────────────────────────────────
fade_colors=(
  "\033[38;5;236m"
  "\033[38;5;238m"
  "\033[38;5;97m"
  "\033[38;5;141m"
  "\033[38;5;177m"
)

fade_in_line() {
  local line="$1"
  local row="$2"
  local steps=${#fade_colors[@]}
  for ((s = 0; s < steps; s++)); do
    move "$row" 0
    printf '%s%b%s%b' "${INDENT}" "${fade_colors[$s]}" "${line}" "${RESET}"
    clear_line
    delay 0.05
  done
}

# ── Phase 2: spotlight sweep (single bun process handles all frames) ──────────
spotlight_sweep() {
  local start_row="$1"
  # Pass all config via env; bun handles the full animation loop in one process
  BANNER_LINES="${banner_lines[*]}" \
    BANNER_LINES_JSON="$(printf '%s\n' "${banner_lines[@]}" | jq -R . | jq -sc .)" \
    BANNER_START_ROW="$start_row" \
    BANNER_INDENT="$INDENT" \
    BANNER_SPEED="$BANNER_SPEED" \
    bun run - <<'TSEOF'
import { setTimeout } from "timers/promises";

const rawLines = JSON.parse(process.env.BANNER_LINES_JSON!) as string[];
const startRow = parseInt(process.env.BANNER_START_ROW!);
const indent = process.env.BANNER_INDENT ?? "";
const speed = parseFloat(process.env.BANNER_SPEED ?? "1.0");

const frames = 28;
const maxLen = 30;
const R = "\x1b[0m";
const spotColors: Record<number, string> = {
  0: "\x1b[38;5;255m",
  1: "\x1b[1m\x1b[38;5;213m",
  2: "\x1b[38;5;213m",
  3: "\x1b[38;5;177m",
  4: "\x1b[38;5;141m",
  5: "\x1b[38;5;97m",
};
const gradPalette = [
  "\x1b[38;5;97m",  "\x1b[38;5;97m",
  "\x1b[38;5;141m", "\x1b[38;5;141m",
  "\x1b[38;5;177m", "\x1b[38;5;177m",
  "\x1b[38;5;213m", "\x1b[1m\x1b[38;5;213m",
];
const dim = "\x1b[38;5;240m";
const seg = new Intl.Segmenter();

const move = (row: number, col: number) =>
  process.stdout.write(`\x1b[${row + 1};${col + 1}H`);
const clearLine = () => process.stdout.write("\x1b[K");

function renderSpotlight(line: string, center: number): string {
  let out = "", i = 0;
  for (const { segment } of seg.segment(line)) {
    const dist = Math.abs(i - center);
    out += (spotColors[dist] ?? dim) + segment + R;
    i++;
  }
  return out;
}

function renderGradient(line: string): string {
  const segs = [...seg.segment(line)];
  const n = segs.length;
  return segs
    .map(({ segment }, i) => {
      const idx = Math.min(
        Math.floor((i * gradPalette.length) / Math.max(n, 1)),
        gradPalette.length - 1,
      );
      return gradPalette[idx] + segment + R;
    })
    .join("");
}

// Spotlight frames
for (let f = 0; f < frames; f++) {
  const center = Math.floor((f * (maxLen + 10)) / frames) - 5;
  let row = startRow;
  for (const line of rawLines) {
    move(row, 0);
    process.stdout.write(indent);
    if (line === "") {
      clearLine();
    } else {
      process.stdout.write(renderSpotlight(line, center));
      clearLine();
    }
    row++;
  }
  await setTimeout(Math.round(30 * speed));
}

// Final gradient render
let row = startRow;
for (const line of rawLines) {
  move(row, 0);
  process.stdout.write(indent);
  if (line === "") {
    clearLine();
  } else {
    process.stdout.write(renderGradient(line));
    clearLine();
  }
  row++;
}
TSEOF
}

# ── Phase 3: animated divider ─────────────────────────────────────────────────
show_divider() {
  local row="$1"
  local div_len=34
  local pad_div=$(((TERM_W - div_len) / 2))
  [[ $pad_div -lt 0 ]] && pad_div=0

  move "$row" 0
  printf '%*s' "$pad_div" ''

  for ((i = 0; i < div_len; i++)); do
    local pct=$((i * 100 / div_len))
    if ((pct < 33)); then
      printf "%b─%b" "${C_DARK}" "${RESET}"
    elif ((pct < 66)); then
      printf "%b─%b" "${C_DIM_P}" "${RESET}"
    else
      printf "%b─%b" "${C_MID}" "${RESET}"
    fi
    delay 0.01
  done
  clear_line
}

# ── Phase 4: typewriter subtitle (ASCII-only, pure bash) ─────────────────────
typewriter() {
  local text="$1"
  local row="$2"
  local text_len=${#text}
  local pad_sub=$(((TERM_W - text_len) / 2))
  [[ $pad_sub -lt 0 ]] && pad_sub=0

  move "$row" 0
  printf '%*s' "$pad_sub" ''

  for ((i = 0; i < text_len; i++)); do
    printf "%b%s%b" "${C_TEAL}" "${text:i:1}" "${RESET}"
    delay 0.03
  done
  clear_line
}

# ── Phase 5: tool badges ──────────────────────────────────────────────────────
show_tools() {
  local row="$1"
  local raw=""
  for tool in "${tools[@]}"; do raw+="[${tool}] "; done
  local raw_len=${#raw}
  local pad_badges=$(((TERM_W - raw_len) / 2))
  [[ $pad_badges -lt 0 ]] && pad_badges=0

  move "$row" 0
  printf '%*s' "$pad_badges" ''

  for tool in "${tools[@]}"; do
    printf "%b[%b%b%s%b%b]%b " "${C_DARK}" "${RESET}" "${C_DIM_P}" "${tool}" "${RESET}" "${C_DARK}" "${RESET}"
    delay 0.06
  done
  clear_line
}

# ── Phase 6: version ──────────────────────────────────────────────────────────
show_version() {
  local row="$1"
  local ver_text="v${VERSION}"
  local ver_len=${#ver_text}
  local pad_ver=$(((TERM_W - ver_len) / 2))
  [[ $pad_ver -lt 0 ]] && pad_ver=0

  move "$row" 0
  printf '%*s' "$pad_ver" ''
  printf "%b%s%b" "${C_GREY}" "${ver_text}" "${RESET}"
  clear_line
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  hide_cursor
  clear_screen

  local BANNER_START=2
  local BANNER_ROWS=${#banner_lines[@]}
  local DIVIDER_ROW=$((BANNER_START + BANNER_ROWS + 1))
  local SUBTITLE_ROW=$((DIVIDER_ROW + 1))
  local TOOLS_ROW=$((SUBTITLE_ROW + 2))
  local VERSION_ROW=$((TOOLS_ROW + 2))

  local row=$BANNER_START
  for line in "${banner_lines[@]}"; do
    if [[ -z $line ]]; then
      ((row++))
      continue
    fi
    fade_in_line "$line" "$row"
    ((row++))
  done

  delay 0.1
  spotlight_sweep "$BANNER_START"
  delay 0.15

  show_divider "$DIVIDER_ROW"
  typewriter "$subtitle" "$SUBTITLE_ROW"
  show_tools "$TOOLS_ROW"
  show_version "$VERSION_ROW"

  move $((VERSION_ROW + 2)) 0
  show_cursor
}

main
