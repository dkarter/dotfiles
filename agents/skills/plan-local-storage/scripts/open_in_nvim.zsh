#!/usr/bin/env zsh
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: zsh ~/.agents/skills/plan-local-storage/scripts/open_in_nvim.zsh <absolute-path>" >&2
  exit 2
fi

plan_file="$1"

if [[ $plan_file != /* ]]; then
  echo "Path must be absolute: $plan_file" >&2
  exit 2
fi

if [[ ! -f $plan_file ]]; then
  echo "File not found: $plan_file" >&2
  exit 1
fi

vim_string="${plan_file//\'/\'\'}"
edit_command=":execute 'edit ' . fnameescape('$vim_string')"

if [[ ${HERDR_ENV:-} != 1 ]] || ! command -v herdr >/dev/null || ! command -v jq >/dev/null; then
  echo "Skipped: not running inside Herdr"
  exit 0
fi

target_pane_id=""
pane_ids=("${(@f)$(herdr pane list --workspace "$HERDR_WORKSPACE_ID" \
  | jq -r --arg tab "$HERDR_TAB_ID" '.result.panes[] | select(.tab_id == $tab) | .pane_id')}")

for pane_id in "${pane_ids[@]}"; do
  if herdr pane process-info --pane "$pane_id" \
    | jq -e '.result.process_info.foreground_processes[]?.name | test("^(n?vim|vi)(\\.exe)?$")' >/dev/null; then
    target_pane_id="$pane_id"
    break
  fi
done

if [[ -z $target_pane_id ]]; then
  if ! command -v nvim >/dev/null; then
    echo "Skipped: Neovim is not installed"
    exit 0
  fi

  direction=$(herdr pane layout --current | jq -er --arg pane "$HERDR_PANE_ID" '
    .result.layout.panes[] | select(.pane_id == $pane) | .rect
    | if .width >= 2 * .height then "right" else "down" end')
  target_pane_id=$(herdr pane split --current --direction "$direction" --cwd "$PWD" --no-focus \
    | jq -er '.result.pane.pane_id')
  herdr pane run "$target_pane_id" "nvim -- ${(qq)plan_file}" >/dev/null
  echo "Started Neovim in pane $target_pane_id"
else
  herdr pane send-keys "$target_pane_id" Escape >/dev/null
  herdr pane run "$target_pane_id" "$edit_command" >/dev/null
  echo "Opened in pane $target_pane_id"
fi
