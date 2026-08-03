#!/usr/bin/env zsh
set -euo pipefail

if [[ $# -ne 1 || $1 != /* || ! -f $1 ]]; then
  print -u2 -- "usage: open_in_nvim.zsh <absolute-existing-file>"
  exit 2
fi

target_file="$1"
vim_file="${target_file//\\/\\\\}"
vim_file="${vim_file//\"/\\\"}"
edit_command=":execute 'tabedit ' . fnameescape(\"$vim_file\")"

editor_pid() {
  jq -r '
    .result.process_info as $info
    | [
        $info.foreground_processes[]?
        | select(.pid == $info.foreground_process_group_id)
        | select(.name | ascii_downcase | test("^(nvim|vim|vi)(\\.exe)?$"))
        | .pid
      ][0] // ""
  ' <<<"$1"
}

if [[ ${HERDR_ENV:-} == 1 ]]; then
  if [[ -z ${HERDR_WORKSPACE_ID:-} || -z ${HERDR_TAB_ID:-} ]]; then
    print -u2 -- "error reason=missing-herdr-context"
    exit 2
  fi

  pane_list="$(herdr pane list --workspace "$HERDR_WORKSPACE_ID")"
  pane_ids=("${(@f)$(jq -r --arg tab "$HERDR_TAB_ID" '.result.panes[] | select(.tab_id == $tab) | .pane_id' <<<"$pane_list")}")
  editor_panes=()
  editor_pids=()

  for pane_id in "${pane_ids[@]}"; do
    process_info="$(herdr pane process-info --pane "$pane_id")"
    pid="$(editor_pid "$process_info")"
    if [[ -n $pid ]]; then
      editor_panes+=("$pane_id")
      editor_pids+=("$pid")
    fi
  done

  if ((${#editor_panes} > 1)); then
    print -u2 -- "error reason=ambiguous-editors panes=${(j:,:)editor_panes}"
    exit 3
  fi

  if ((${#editor_panes} == 1)); then
    target_pane="${editor_panes[1]}"
    original_pid="${editor_pids[1]}"
    herdr pane send-keys "$target_pane" Escape ctrl+backslash ctrl+n >/dev/null
    herdr pane send-text "$target_pane" "$edit_command" >/dev/null
    herdr pane send-keys "$target_pane" Enter >/dev/null

    process_info="$(herdr pane process-info --pane "$target_pane")"
    if [[ $(editor_pid "$process_info") != "$original_pid" ]]; then
      print -u2 -- "error reason=editor-process-changed pane=$target_pane"
      exit 4
    fi

    print -- "opened multiplexer=herdr pane=$target_pane pid=$original_pid created=false"
    exit 0
  fi

  caller_pane="${HERDR_PANE_ID:-}"
  if [[ -z $caller_pane ]]; then
    caller_pane="$(herdr pane current --current | jq -er --arg tab "$HERDR_TAB_ID" '.result.pane | select(.tab_id == $tab) | .pane_id')"
  fi

  if ((!${pane_ids[(Ie)$caller_pane]})); then
    print -u2 -- "error reason=caller-pane-outside-context"
    exit 2
  fi

  split_result="$(herdr pane split "$caller_pane" --direction right --cwd "${target_file:h}" --no-focus)"
  target_pane="$(jq -er --arg tab "$HERDR_TAB_ID" '.result.pane | select(.tab_id == $tab) | .pane_id' <<<"$split_result")"
  herdr pane run "$target_pane" "exec nvim -- ${(q)target_file}" >/dev/null
  print -- "opened multiplexer=herdr pane=$target_pane created=true"
  exit 0
fi

if [[ -n ${TMUX:-} && -n ${TMUX_PANE:-} ]]; then
  pane_lines="$(tmux list-panes -t "$TMUX_PANE" -F '#{pane_id}|#{pane_current_command}')"
  editor_panes=()

  while IFS='|' read -r pane_id pane_command; do
    case "${(L)pane_command}" in
      nvim | vim | vi | nvim.exe | vim.exe | vi.exe) editor_panes+=("$pane_id") ;;
    esac
  done <<<"$pane_lines"

  if ((${#editor_panes} > 1)); then
    print -u2 -- "error reason=ambiguous-editors panes=${(j:,:)editor_panes}"
    exit 3
  fi

  if ((${#editor_panes} == 0)); then
    print -- "skipped reason=no-editor multiplexer=tmux"
    exit 0
  fi

  target_pane="${editor_panes[1]}"
  tmux send-keys -t "$target_pane" Escape 'C-\' C-n
  tmux send-keys -l -t "$target_pane" "$edit_command"
  tmux send-keys -t "$target_pane" Enter
  print -- "opened multiplexer=tmux pane=$target_pane"
  exit 0
fi

print -- "skipped reason=no-multiplexer"
