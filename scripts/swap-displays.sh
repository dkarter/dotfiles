#!/usr/bin/env bash

set -euo pipefail

dry_run=false

usage() {
  cat <<'USAGE'
Usage: swap-displays.sh [--dry-run]

Swaps the order of the two connected macOS displays using displayplacer.

Options:
  -n, --dry-run  Print the displayplacer command without running it
  -h, --help     Show this help
USAGE
}

fail() {
  printf 'swap-displays: %s\n' "$*" >&2
  exit 1
}

abs() {
  local value="$1"

  if ((value < 0)); then
    printf '%s\n' "$((-value))"
  else
    printf '%s\n' "$value"
  fi
}

replace_origin() {
  local config="$1"
  local x="$2"
  local y="$3"

  if [[ $config =~ ^(.*origin:\()-?[0-9]+,-?[0-9]+(\).*)$ ]]; then
    printf '%s%s,%s%s\n' "${BASH_REMATCH[1]}" "$x" "$y" "${BASH_REMATCH[2]}"
  else
    fail "could not replace origin in displayplacer config: $config"
  fi
}

print_command() {
  local arg

  printf 'displayplacer'
  for arg in "$@"; do
    printf ' %q' "$arg"
  done
  printf '\n'
}

while (($# > 0)); do
  case "$1" in
    -n | --dry-run)
      dry_run=true
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [[ $(uname -s) != Darwin ]]; then
  fail "this script only works on macOS"
fi

if ! command -v displayplacer >/dev/null 2>&1; then
  fail "displayplacer is required; install it with: brew install displayplacer"
fi

displayplacer_output="$(displayplacer list)"
current_command=""

while IFS= read -r line; do
  case "$line" in
    displayplacer\ \"*) current_command="$line" ;;
  esac
done <<<"$displayplacer_output"

if [[ -z $current_command ]]; then
  fail "could not find current displayplacer arrangement command"
fi

configs=()
remaining="$current_command"

while [[ $remaining =~ \"([^\"]+)\" ]]; do
  configs+=("${BASH_REMATCH[1]}")
  remaining="${remaining#*\""${BASH_REMATCH[1]}"\"}"
done

if ((${#configs[@]} != 2)); then
  fail "expected exactly two displays; found ${#configs[@]}"
fi

xs=()
ys=()
widths=()
heights=()
main=-1

for i in "${!configs[@]}"; do
  config="${configs[$i]}"

  if [[ $config =~ origin:\((-?[0-9]+),(-?[0-9]+)\) ]]; then
    xs[i]="${BASH_REMATCH[1]}"
    ys[i]="${BASH_REMATCH[2]}"

    if ((xs[i] == 0 && ys[i] == 0)); then
      main="$i"
    fi
  else
    fail "could not parse origin from displayplacer config: $config"
  fi

  if [[ $config =~ res:([0-9]+)x([0-9]+) ]]; then
    widths[i]="${BASH_REMATCH[1]}"
    heights[i]="${BASH_REMATCH[2]}"
  else
    fail "could not parse resolution from displayplacer config: $config"
  fi
done

if ((main == -1)); then
  fail "could not determine the main display at origin (0,0)"
fi

other=$((1 - main))
dx="$(abs "$((xs[main] - xs[other]))")"
dy="$(abs "$((ys[main] - ys[other]))")"
new_configs=()

if ((dx >= dy)); then
  if ((xs[other] >= xs[main])); then
    new_other_x="-$((widths[other]))"
  else
    new_other_x="${widths[main]}"
  fi

  new_configs[main]="$(replace_origin "${configs[$main]}" 0 0)"
  new_configs[other]="$(replace_origin "${configs[$other]}" "$new_other_x" "${ys[$other]}")"
else
  if ((ys[other] >= ys[main])); then
    new_other_y="-$((heights[other]))"
  else
    new_other_y="${heights[main]}"
  fi

  new_configs[main]="$(replace_origin "${configs[$main]}" 0 0)"
  new_configs[other]="$(replace_origin "${configs[$other]}" "${xs[$other]}" "$new_other_y")"
fi

if [[ $dry_run == true ]]; then
  print_command "${new_configs[@]}"
  exit 0
fi

displayplacer "${new_configs[@]}"
printf 'Display order swapped.\n'
