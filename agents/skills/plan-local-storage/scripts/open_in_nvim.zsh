#!/usr/bin/env zsh
set -euo pipefail

if [[ $# -ne 1 ]]; then
  print -u2 -- "usage: open_in_nvim.zsh <absolute-existing-file>"
  exit 2
fi

target_file="$1"

if [[ $target_file != /* ]]; then
  print -u2 -- "error reason=path-not-absolute"
  exit 2
fi

if [[ ! -f $target_file ]]; then
  print -u2 -- "error reason=file-not-found"
  exit 1
fi

capture_command() {
  local label="$1"
  local command_status
  shift

  REPLY="$("$@")" || {
    command_status=$?
    print -u2 -- "error reason=command-failed command=$label status=$command_status"
    return "$command_status"
  }
}

run_command() {
  local label="$1"
  local command_status
  shift

  "$@" || {
    command_status=$?
    print -u2 -- "error reason=command-failed command=$label status=$command_status"
    return "$command_status"
  }
}

editor_record_from_json() {
  jq -r '
    .result.process_info as $info
    | if ($info.foreground_processes | type) != "array" then
        error("invalid process info")
      else
        [
          $info.foreground_processes[]
          | select(.pid == $info.foreground_process_group_id)
          | select(.name | ascii_downcase | test("^(nvim|vim|vi)(\\.exe)?$"))
          | "\(.pid)\t\(.name)"
        ][0] // ""
      end
  ' <<<"$1"
}

pane_id_in_context() {
  jq -er --arg workspace "$HERDR_WORKSPACE_ID" --arg tab "$HERDR_TAB_ID" '
    .result.pane
    | select(.workspace_id == $workspace and .tab_id == $tab)
    | .pane_id
  ' <<<"$1"
}

open_in_herdr() {
  if [[ -z ${HERDR_WORKSPACE_ID:-} || -z ${HERDR_TAB_ID:-} ]]; then
    print -u2 -- "error reason=missing-herdr-context"
    return 2
  fi

  local pane_list pane_lines pane_id process_json record
  local -a pane_ids editor_panes editor_pids
  local command_count=1
  local lookup_count=1

  capture_command herdr-pane-list herdr pane list --workspace "$HERDR_WORKSPACE_ID"
  pane_list="$REPLY"
  if ! pane_lines="$(jq -r --arg workspace "$HERDR_WORKSPACE_ID" --arg tab "$HERDR_TAB_ID" '
    .result.panes as $panes
    | if ($panes | type) != "array" then
        error("invalid pane list")
      else
        $panes[]
        | select(.workspace_id == $workspace and .tab_id == $tab)
        | .pane_id
      end
  ' <<<"$pane_list")"; then
    print -u2 -- "error reason=invalid-herdr-response command=pane-list"
    return 5
  fi
  pane_ids=()
  if [[ -n $pane_lines ]]; then
    pane_ids=("${(@f)pane_lines}")
  fi

  for pane_id in "${pane_ids[@]}"; do
    capture_command herdr-process-info herdr pane process-info --pane "$pane_id"
    process_json="$REPLY"
    ((command_count++))
    ((lookup_count++))
    if ! record="$(editor_record_from_json "$process_json")"; then
      print -u2 -- "error reason=invalid-herdr-response command=process-info pane=$pane_id"
      return 5
    fi
    if [[ -n $record ]]; then
      editor_panes+=("$pane_id")
      editor_pids+=("${record%%$'\t'*}")
      ((${#editor_panes} == 2)) && break
    fi
  done

  if ((${#editor_panes} == 0)); then
    create_herdr_editor "$command_count" "$lookup_count" "${(j:,:)pane_ids}"
    return
  fi

  if ((${#editor_panes} > 1)); then
    print -u2 -- "error reason=ambiguous-editors multiplexer=herdr panes=${(j:,:)editor_panes}"
    return 3
  fi

  local target_pane="${editor_panes[1]}"
  local editor_pid="${editor_pids[1]}"
  prepare_ack
  trap cleanup_ack EXIT
  build_edit_command

  run_command herdr-send-escape herdr pane send-keys "$target_pane" Escape ctrl+backslash ctrl+n >/dev/null
  run_command herdr-send-text herdr pane send-text "$target_pane" "$edit_command" >/dev/null
  run_command herdr-send-enter herdr pane send-keys "$target_pane" Enter >/dev/null
  command_count=$((command_count + 3))

  if ! wait_for_ack; then
    print -u2 -- "error reason=target-not-verified multiplexer=herdr pane=$target_pane"
    return 4
  fi

  capture_command herdr-process-info herdr pane process-info --pane "$target_pane"
  process_json="$REPLY"
  ((command_count++))
  if ! record="$(editor_record_from_json "$process_json")"; then
    print -u2 -- "error reason=invalid-herdr-response command=process-info pane=$target_pane"
    return 5
  fi
  if [[ -z $record || ${record%%$'\t'*} != "$editor_pid" ]]; then
    print -u2 -- "error reason=editor-process-changed multiplexer=herdr pane=$target_pane"
    return 4
  fi

  cleanup_ack
  trap - EXIT
  print -- "opened multiplexer=herdr pane=$target_pane pid=$editor_pid created=false lookup_commands=$lookup_count commands=$command_count"
}

create_herdr_editor() {
  local command_count="$1"
  local lookup_count="$2"
  local current_panes=",$3,"
  local caller_pane="${HERDR_PANE_ID:-}"
  local current_json split_json process_json record target_pane

  if [[ -z $caller_pane ]]; then
    capture_command herdr-pane-current herdr pane current --current
    current_json="$REPLY"
    ((command_count++))
    ((lookup_count++))
    if ! caller_pane="$(pane_id_in_context "$current_json")"; then
      print -u2 -- "error reason=caller-pane-outside-context"
      return 2
    fi
  elif [[ $current_panes != *",$caller_pane,"* ]]; then
    print -u2 -- "error reason=caller-pane-outside-context pane=$caller_pane"
    return 2
  fi

  prepare_ack
  trap cleanup_ack EXIT
  build_launch_command
  capture_command herdr-pane-split herdr pane split "$caller_pane" --direction right --cwd "${target_file:h}" --no-focus
  split_json="$REPLY"
  ((command_count++))
  if ! CREATED_HERDR_PANE="$(jq -er '.result.pane.pane_id' <<<"$split_json")"; then
    print -u2 -- "error reason=invalid-herdr-response command=pane-split"
    return 5
  fi
  CREATED_HERDR_PANE_VERIFIED=0
  trap cleanup_created_herdr_pane EXIT
  if ! target_pane="$(pane_id_in_context "$split_json")"; then
    print -u2 -- "error reason=created-pane-outside-context pane=$CREATED_HERDR_PANE"
    return 5
  fi
  run_command herdr-pane-run herdr pane run "$target_pane" "$launch_command" >/dev/null
  ((command_count++))

  if ! wait_for_ack "${OPEN_IN_NVIM_LAUNCH_TIMEOUT_MS:-10000}"; then
    print -u2 -- "error reason=target-not-verified multiplexer=herdr pane=$target_pane created=true"
    return 4
  fi

  capture_command herdr-process-info herdr pane process-info --pane "$target_pane"
  process_json="$REPLY"
  ((command_count++))
  if ! record="$(editor_record_from_json "$process_json")"; then
    print -u2 -- "error reason=invalid-herdr-response command=process-info pane=$target_pane"
    return 5
  fi
  if [[ -z $record ]]; then
    print -u2 -- "error reason=editor-process-changed multiplexer=herdr pane=$target_pane created=true"
    return 4
  fi

  CREATED_HERDR_PANE_VERIFIED=1
  cleanup_ack
  trap - EXIT
  print -- "opened multiplexer=herdr pane=$target_pane pid=${record%%$'\t'*} created=true lookup_commands=$lookup_count commands=$command_count"
}

tmux_editor_pid() {
  local pane_tty="$1"
  local pid tpgid process_name basename

  while read -r pid tpgid process_name; do
    basename="${process_name:t}"
    basename="${(L)basename}"
    if [[ $pid == "$tpgid" && $basename == (nvim|vim|vi|nvim.exe|vim.exe|vi.exe) ]]; then
      print -- "$pid"
      return 0
    fi
  done < <(ps -o pid=,tpgid=,comm= -t "${pane_tty#/dev/}")

  return 1
}

open_in_tmux() {
  local caller_pane="${TMUX_PANE:-}"
  if [[ -z $caller_pane ]]; then
    print -u2 -- "error reason=missing-tmux-context"
    return 2
  fi

  local window_id pane_lines pane_id pane_command pane_tty editor_pid row_window_id
  local -a editor_panes editor_pids editor_ttys
  capture_command tmux-list-panes tmux list-panes -t "$caller_pane" -F '#{window_id}|#{pane_id}|#{pane_current_command}|#{pane_tty}'
  pane_lines="$REPLY"

  while IFS='|' read -r row_window_id pane_id pane_command pane_tty; do
    window_id="${window_id:-$row_window_id}"
    case "${(L)pane_command}" in
      nvim | vim | vi | nvim.exe | vim.exe | vi.exe)
        editor_pid="$(tmux_editor_pid "$pane_tty" 2>/dev/null || true)"
        if [[ -n $editor_pid ]]; then
          editor_panes+=("$pane_id")
          editor_pids+=("$editor_pid")
          editor_ttys+=("$pane_tty")
        fi
        ;;
    esac
  done <<<"$pane_lines"

  if ((${#editor_panes} == 0)); then
    print -- "skipped reason=no-editor multiplexer=tmux window=$window_id"
    return 0
  fi

  if ((${#editor_panes} > 1)); then
    print -u2 -- "error reason=ambiguous-editors multiplexer=tmux panes=${(j:,:)editor_panes}"
    return 3
  fi

  local target_pane="${editor_panes[1]}"
  editor_pid="${editor_pids[1]}"
  pane_tty="${editor_ttys[1]}"
  prepare_ack
  trap cleanup_ack EXIT
  build_edit_command
  run_command tmux-send-escape tmux send-keys -t "$target_pane" Escape 'C-\' C-n
  run_command tmux-send-text tmux send-keys -l -t "$target_pane" "$edit_command"
  run_command tmux-send-enter tmux send-keys -t "$target_pane" Enter

  if ! wait_for_ack; then
    print -u2 -- "error reason=target-not-verified multiplexer=tmux pane=$target_pane"
    return 4
  fi

  if [[ $(tmux_editor_pid "$pane_tty" 2>/dev/null || true) != "$editor_pid" ]]; then
    print -u2 -- "error reason=editor-process-changed multiplexer=tmux pane=$target_pane"
    return 4
  fi

  cleanup_ack
  trap - EXIT
  print -- "opened multiplexer=tmux pane=$target_pane pid=$editor_pid"
}

prepare_ack() {
  vim_file="${target_file//\\/\\\\}"
  vim_file="${vim_file//\"/\\\"}"
  vim_file="${vim_file//$'\n'/\\n}"
  zmodload zsh/datetime
  token="OPEN_IN_NVIM_${$}_${EPOCHREALTIME//[^0-9]/}_${RANDOM}"
  token_split=$((${#token} / 2))
  token_left="${token[1,token_split]}"
  token_right="${token[$((token_split + 1)),-1]}"
  capture_command create-ack-dir mktemp -d "${TMPDIR:-/tmp}/open-in-nvim.XXXXXX"
  ACK_DIR="$REPLY"
  ACK_FILE="$ACK_DIR/ack"
}

build_edit_command() {
  local vim_ack_file="${ACK_FILE//\\/\\\\}"
  vim_ack_file="${vim_ack_file//\"/\\\"}"
  # Keep the full token out of the typed text so only executed Neovim code can acknowledge success.
  edit_command=":execute 'tabedit ' . fnameescape(\"$vim_file\") | if resolve(expand('%:p')) ==# resolve(\"$vim_file\") | call writefile(['$token_left' . '$token_right'], \"$vim_ack_file\") | endif"
}

build_launch_command() {
  local vim_ack_file="${ACK_FILE//\\/\\\\}"
  vim_ack_file="${vim_ack_file//\"/\\\"}"
  local verify_command="if resolve(expand('%:p')) ==# resolve(\"$vim_file\") | call writefile(['$token'], \"$vim_ack_file\") | endif"
  launch_command="exec nvim -c ${(q)verify_command} -- ${(q)target_file}"
}

wait_for_ack() {
  local timeout_ms="${1:-${OPEN_IN_NVIM_VERIFY_TIMEOUT_MS:-2000}}"
  local deadline=$((EPOCHREALTIME + timeout_ms / 1000.0))
  zmodload zsh/zselect

  while [[ ! -s $ACK_FILE ]]; do
    ((EPOCHREALTIME < deadline)) || return 1
    zselect -t 1 || true
  done

  [[ $(<$ACK_FILE) == "$token" ]]
}

cleanup_ack() {
  if [[ -n ${ACK_FILE:-} ]]; then
    rm -f -- "$ACK_FILE"
  fi
  if [[ -n ${ACK_DIR:-} ]]; then
    rmdir -- "$ACK_DIR" 2>/dev/null
  fi
}

cleanup_created_herdr_pane() {
  cleanup_ack
  if [[ ${CREATED_HERDR_PANE_VERIFIED:-0} != 1 && -n ${CREATED_HERDR_PANE:-} ]]; then
    herdr pane close "$CREATED_HERDR_PANE" >/dev/null 2>&1 || true
  fi
}

if [[ ${HERDR_ENV:-} == 1 ]]; then
  open_in_herdr
elif [[ -n ${TMUX:-} ]]; then
  open_in_tmux
else
  print -- "skipped reason=no-multiplexer"
fi
