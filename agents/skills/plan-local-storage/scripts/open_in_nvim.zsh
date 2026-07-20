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

if [[ ${HERDR_ENV:-} == 1 ]] && command -v herdr >/dev/null && command -v jq >/dev/null; then
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
    echo "Skipped: no nvim/vim pane in current Herdr tab"
    exit 0
  fi

  herdr pane send-keys "$target_pane_id" Escape >/dev/null
  herdr pane run "$target_pane_id" "$edit_command" >/dev/null
elif [[ -n ${TMUX:-} ]]; then
  current_window_id="$(tmux display-message -p '#{window_id}')"
  target_pane_id="$({
    tmux list-panes -t "$current_window_id" -F '#{pane_id} #{pane_current_command}' \
      | while IFS=' ' read -r pane_id pane_cmd; do
        case "$pane_cmd" in
          nvim | vim | vi)
            printf '%s\n' "$pane_id"
            break
            ;;
        esac
      done
  } || true)"

  if [[ -z $target_pane_id ]]; then
    echo "Skipped: no nvim/vim pane in current tmux window"
    exit 0
  fi

  tmux send-keys -t "$target_pane_id" Escape "$edit_command" Enter
else
  echo "Skipped: not running inside Herdr or tmux"
  exit 0
fi

echo "Opened in pane $target_pane_id"
