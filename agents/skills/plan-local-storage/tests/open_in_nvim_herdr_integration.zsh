#!/usr/bin/env zsh
set -euo pipefail

for dependency in herdr jq nvim tmux; do
  if ! command -v "$dependency" >/dev/null; then
    print -- "ok: Herdr integration skipped (missing $dependency)"
    exit 0
  fi
done

script_dir="${0:A:h}"
helper="${script_dir:h}/scripts/open_in_nvim.zsh"
real_herdr="$(command -v herdr)"
session="open-in-nvim-test-$$"
host_socket="open-in-nvim-host-$$"
tmp_root="$(mktemp -d "${TMPDIR:-/tmp}/open-in-nvim-herdr.XXXXXX")"

cleanup() {
  env -u HERDR_ENV "$real_herdr" session stop "$session" >/dev/null 2>&1 || true
  env -u HERDR_ENV "$real_herdr" session delete "$session" >/dev/null 2>&1 || true
  tmux -L "$host_socket" kill-server >/dev/null 2>&1 || true
  rm -rf -- "$tmp_root"
}
trap cleanup EXIT

fail() {
  print -u2 -- "not ok: $1"
  exit 1
}

wait_for_server() {
  local attempt
  for attempt in {1..200}; do
    if env -u HERDR_ENV "$real_herdr" --session "$session" status server >/dev/null 2>&1; then
      return 0
    fi
    sleep 0.01
  done
  return 1
}

wait_for_file() {
  local file="$1"
  local attempt
  for attempt in {1..100}; do
    [[ -s $file ]] && return 0
    sleep 0.01
  done
  return 1
}

source_file="$tmp_root/source.elixir"
target_file="$tmp_root/target space's ü.md"
inspect_file="$tmp_root/inspect.txt"
helper_calls="$tmp_root/helper-calls"
nvim_ready="$tmp_root/nvim-ready"
created_target="$tmp_root/-created target's ü;\$.md"
created_inspect="$tmp_root/created-inspect.txt"
mkdir "$tmp_root/bin"
print -r -- 'ORIGINAL' >"$source_file"
print -r -- 'TARGET' >"$target_file"
print -r -- 'CREATED' >"$created_target"

tmux -L "$host_socket" new-session -d -s host "env -u HERDR_ENV ${(q)real_herdr} --session ${(q)session} server"
wait_for_server || fail 'isolated Herdr server did not start'

workspace_json="$(env -u HERDR_ENV "$real_herdr" --session "$session" workspace create --cwd "$tmp_root" --label integration --no-focus)"
workspace_id="$(jq -er '.result.workspace.workspace_id' <<<"$workspace_json")"
tab_id="$(jq -er '.result.tab.tab_id' <<<"$workspace_json")"
pane_id="$(jq -er '.result.root_pane.pane_id' <<<"$workspace_json")"

ready_command="call writefile(['ready'], '${nvim_ready//\'/\'\'}')"
env -u HERDR_ENV "$real_herdr" --session "$session" pane run "$pane_id" \
  "exec nvim --clean -c ${(q)ready_command} -- ${(q)source_file}"
wait_for_file "$nvim_ready" || fail 'isolated Neovim did not start'
process_json="$(env -u HERDR_ENV "$real_herdr" --session "$session" pane process-info --pane "$pane_id")"
pid_before="$(jq -er '
  .result.process_info as $info
  | $info.foreground_processes[]
  | select(.pid == $info.foreground_process_group_id and .name == "nvim")
  | .pid
' <<<"$process_json")"

env -u HERDR_ENV "$real_herdr" --session "$session" pane send-keys "$pane_id" G A
env -u HERDR_ENV "$real_herdr" --session "$session" pane send-text "$pane_id" __UNSAVED_HERDR_SENTINEL

print -r -- '#!/bin/sh' >"$tmp_root/bin/herdr"
print -r -- "printf '%s\\n' \"\$*\" >> ${(q)helper_calls}" >>"$tmp_root/bin/herdr"
print -r -- "exec ${(q)real_herdr} --session ${(q)session} \"\$@\"" >>"$tmp_root/bin/herdr"
chmod +x "$tmp_root/bin/herdr"

zmodload zsh/datetime
: >"$helper_calls"
started_at="$EPOCHREALTIME"
output="$(env PATH="$tmp_root/bin:$PATH" HERDR_ENV=1 HERDR_WORKSPACE_ID="$workspace_id" HERDR_TAB_ID="$tab_id" \
  zsh "$helper" "$target_file")"
runtime_ms=$(((EPOCHREALTIME - started_at) * 1000))
[[ $output == "opened multiplexer=herdr pane=$pane_id pid=$pid_before created=false lookup_commands=2 commands=6" ]] \
  || fail "unexpected helper output: $output"
[[ $(wc -l <"$helper_calls" | tr -d ' ') == 6 ]] || fail 'measured reuse command count is not 6'

process_json="$(env -u HERDR_ENV "$real_herdr" --session "$session" pane process-info --pane "$pane_id")"
pid_after="$(jq -er '
  .result.process_info as $info
  | $info.foreground_processes[]
  | select(.pid == $info.foreground_process_group_id and .name == "nvim")
  | .pid
' <<<"$process_json")"
[[ $pid_after == "$pid_before" ]] || fail 'Neovim PID changed'

vim_source="${source_file//\'/\'\'}"
vim_inspect="${inspect_file//\'/\'\'}"
inspect_command=":call writefile([expand('%:p'), string(getbufvar(bufnr('$vim_source'), '&modified'))] + getbufline(bufnr('$vim_source'), 1, '\$'), '$vim_inspect', 'b')"
env -u HERDR_ENV "$real_herdr" --session "$session" pane send-keys "$pane_id" Escape
env -u HERDR_ENV "$real_herdr" --session "$session" pane send-text "$pane_id" "$inspect_command"
env -u HERDR_ENV "$real_herdr" --session "$session" pane send-keys "$pane_id" Enter
wait_for_file "$inspect_file" || fail 'Neovim inspection did not complete'

inspection=("${(@f)$(<$inspect_file)}")
[[ ${inspection[1]} == "$target_file" ]] || fail 'requested target is not visible'
[[ ${inspection[2]} == 1 ]] || fail 'source buffer is no longer modified'
[[ ${inspection[3]} == 'ORIGINAL__UNSAVED_HERDR_SENTINEL' ]] || fail 'source buffer contents changed'
[[ ${inspection[3]} != *':execute '\''tabedit'* ]] || fail 'command text was inserted into source buffer'

create_workspace_json="$(env -u HERDR_ENV "$real_herdr" --session "$session" workspace create --cwd "$tmp_root" --label create-integration --no-focus)"
create_workspace_id="$(jq -er '.result.workspace.workspace_id' <<<"$create_workspace_json")"
create_tab_id="$(jq -er '.result.tab.tab_id' <<<"$create_workspace_json")"
caller_pane_id="$(jq -er '.result.root_pane.pane_id' <<<"$create_workspace_json")"

: >"$helper_calls"
started_at="$EPOCHREALTIME"
created_output="$(env PATH="$tmp_root/bin:$PATH" HERDR_ENV=1 HERDR_WORKSPACE_ID="$create_workspace_id" \
  HERDR_TAB_ID="$create_tab_id" HERDR_PANE_ID="$caller_pane_id" zsh "$helper" "$created_target")"
create_runtime_ms=$(((EPOCHREALTIME - started_at) * 1000))
created_pane="${${created_output#*pane=}%% *}"
created_pid="${${created_output#*pid=}%% *}"
[[ $created_output == *'created=true lookup_commands=2 commands=5' ]] || fail "unexpected create output: $created_output"
[[ $(wc -l <"$helper_calls" | tr -d ' ') == 5 ]] || fail 'measured create command count is not 5'
[[ $created_pane != "$pane_id" && $created_pane != "$caller_pane_id" ]] || fail 'new editor reused an unrelated pane'

created_pane_json="$(env -u HERDR_ENV "$real_herdr" --session "$session" pane get "$created_pane")"
jq -e --arg workspace "$create_workspace_id" --arg tab "$create_tab_id" \
  '.result.pane | select(.workspace_id == $workspace and .tab_id == $tab)' >/dev/null <<<"$created_pane_json" \
  || fail 'new editor pane is outside the caller context'
created_process_json="$(env -u HERDR_ENV "$real_herdr" --session "$session" pane process-info --pane "$created_pane")"
created_process_pid="$(jq -er '
  .result.process_info as $info
  | $info.foreground_processes[]
  | select(.pid == $info.foreground_process_group_id and .name == "nvim")
  | .pid
' <<<"$created_process_json")"
[[ $created_process_pid == "$created_pid" ]] || fail 'created Neovim PID does not match helper output'

vim_created_inspect="${created_inspect//\'/\'\'}"
created_inspect_command=":call writefile([expand('%:p')], '$vim_created_inspect', 'b')"
env -u HERDR_ENV "$real_herdr" --session "$session" pane send-keys "$created_pane" Escape
env -u HERDR_ENV "$real_herdr" --session "$session" pane send-text "$created_pane" "$created_inspect_command"
env -u HERDR_ENV "$real_herdr" --session "$session" pane send-keys "$created_pane" Enter
wait_for_file "$created_inspect" || fail 'created Neovim inspection did not complete'
[[ $(realpath "$(<$created_inspect)") == "$(realpath "$created_target")" ]] || fail "created Neovim target mismatch: $(<$created_inspect)"

printf 'ok: isolated Herdr/Neovim integration passed reuse_runtime_ms=%.3f reuse_commands=6 create_runtime_ms=%.3f create_commands=5\n' \
  "$runtime_ms" "$create_runtime_ms"
