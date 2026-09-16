#!/usr/bin/env bash
set -e -u -o pipefail

# Configuration - override via environment variables
TUICR_PANE_POSITION="${TUICR_PANE_POSITION:-top}" # top or bottom
TUICR_PANE_SIZE="${TUICR_PANE_SIZE:-80}"          # percentage of screen

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
  echo -e "${GREEN}[tuicr]${NC} $*"
}

log_warn() {
  echo -e "${YELLOW}[tuicr]${NC} $*"
}

log_error() {
  echo -e "${RED}[tuicr]${NC} $*"
}

usage() {
  cat <<EOF
Usage: $(basename "$0") [directory]

Launch tuicr in a Herdr split pane to review git changes.

Arguments:
  directory    Git repository directory to review (default: current directory)

Environment variables:
  TUICR_PANE_POSITION   Position of tuicr pane: top or bottom (default: top)
  TUICR_PANE_SIZE       Size of pane as percentage (default: 80)

Examples:
  $(basename "$0")                    # Review changes in current directory
  $(basename "$0") ~/project          # Review changes in ~/project
  TUICR_PANE_SIZE=70 $(basename "$0") # Use 70% of screen
EOF
}

check_herdr() {
  [[ ${HERDR_ENV:-} == 1 ]] && command -v herdr &>/dev/null && command -v jq &>/dev/null
}

check_tuicr() {
  if ! command -v tuicr &>/dev/null; then
    log_error "tuicr not found. Install it first."
    return 1
  fi
  return 0
}

check_tuicr_stdout_support() {
  # Check if tuicr supports --stdout flag
  tuicr --help 2>&1 | grep -q -- '--stdout'
}

check_git_repo() {
  local dir="$1"
  if ! git -C "$dir" rev-parse --git-dir &>/dev/null; then
    log_error "Not a git repository: $dir"
    return 1
  fi
  return 0
}

prepare_tuicr_output() {
  output_file=""
  tuicr_cmd="tuicr"
  use_stdout=false

  if check_tuicr_stdout_support; then
    output_file=$(mktemp /tmp/tuicr-output.XXXXXX)
    printf -v quoted_output_file '%q' "$output_file"
    tuicr_cmd="tuicr --stdout > $quoted_output_file"
    use_stdout=true
    log_info "Using --stdout mode (output will be captured)"
  else
    log_warn "tuicr --stdout not supported, output will be copied to clipboard"
  fi
}

print_tuicr_output() {
  if [[ $use_stdout == true ]] && [[ -f $output_file ]]; then
    if [[ -s $output_file ]]; then
      echo ""
      echo "=== TUICR INSTRUCTIONS ==="
      cat "$output_file"
      echo "=== END TUICR INSTRUCTIONS ==="
    else
      log_info "No instructions exported from tuicr"
      log_info "If you exported to clipboard, paste the instructions here"
    fi
    rm -f "$output_file"
    output_file=""
  else
    log_info "If you exported instructions, they are in your clipboard - paste them here"
  fi
}

launch_tuicr_herdr_pane() {
  local target_dir="$1"
  local ratio
  cleanup_pane_id=""

  cleanup_herdr_launch() {
    [[ -z ${cleanup_pane_id:-} ]] || herdr pane close "$cleanup_pane_id" >/dev/null 2>&1 || true
    [[ -z ${output_file:-} ]] || rm -f "$output_file"
  }
  trap cleanup_herdr_launch EXIT

  printf -v ratio '%d.%02d' "$((TUICR_PANE_SIZE / 100))" "$((TUICR_PANE_SIZE % 100))"

  log_info "Launching tuicr in Herdr ${TUICR_PANE_POSITION} pane (${TUICR_PANE_SIZE}%)"
  log_info "Directory: $target_dir"

  prepare_tuicr_output

  local split_result new_pane_id
  split_result=$(herdr pane split --current --direction down --ratio "$ratio" --cwd "$target_dir" --focus)
  new_pane_id=$(jq -er '.result.pane.pane_id' <<<"$split_result")
  cleanup_pane_id="$new_pane_id"
  herdr pane rename "$new_pane_id" tuicr >/dev/null

  if [[ $TUICR_PANE_POSITION == "top" ]]; then
    herdr pane swap --pane "$new_pane_id" --direction up >/dev/null
  fi
  herdr pane zoom "$new_pane_id" --on >/dev/null

  local marker_prefix="TUICR_"
  local marker_suffix="FINISHED_$$"
  local finished_marker="${marker_prefix}${marker_suffix}"
  printf -v quoted_target_dir '%q' "$target_dir"
  printf -v quoted_marker_prefix '%q' "$marker_prefix"
  printf -v quoted_marker_suffix '%q' "$marker_suffix"
  herdr pane run "$new_pane_id" "cd $quoted_target_dir && $tuicr_cmd; printf '\\n%s%s\\n' $quoted_marker_prefix $quoted_marker_suffix"

  log_info "tuicr is running in pane $new_pane_id"
  log_info "Waiting for tuicr to exit..."
  if ! herdr pane wait-output "$new_pane_id" --match "$finished_marker" --source recent-unwrapped --timeout 3600000 >/dev/null; then
    log_error "Failed while waiting for tuicr pane $new_pane_id"
    return 1
  fi
  herdr pane close "$new_pane_id" >/dev/null
  cleanup_pane_id=""

  log_info "tuicr finished"
  print_tuicr_output
  trap - EXIT
}

main() {
  # Handle help
  if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
    usage
    exit 0
  fi

  # Check for tuicr
  if ! check_tuicr; then
    exit 1
  fi

  # Determine target directory
  local target_dir="${1:-.}"
  target_dir=$(cd "$target_dir" && pwd) # Get absolute path

  # Verify it's a git repo
  if ! check_git_repo "$target_dir"; then
    exit 1
  fi

  if ! check_herdr; then
    log_error "Not running inside Herdr!"
    echo ""
    echo "To use tuicr with your coding agent, run that agent inside Herdr."
    echo ""
    echo "1. Exit the current agent session."
    echo ""
    echo "2. Restart the agent inside Herdr."
    echo ""
    echo "3. Then run /tuicr again."
    exit 1
  fi

  launch_tuicr_herdr_pane "$target_dir"
}

main "$@"
