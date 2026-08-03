#!/usr/bin/env zsh
set -euo pipefail

test_dir="${0:A:h}"
helper="${test_dir:h}/scripts/open_in_nvim.zsh"
tmp_root="$(mktemp -d "${TMPDIR:-/tmp}/open-in-nvim-test.XXXXXX")"
tmux_socket="open-in-nvim-test-$$"
trap 'tmux -L "$tmux_socket" kill-server 2>/dev/null || true; rm -rf "$tmp_root"' EXIT

fail() {
  print -u2 -- "not ok: $1"
  exit 1
}

assert_contains() {
  print -r -- "$1" | grep -F -- "$2" >/dev/null || fail "expected <$2> in <$1>"
}

write_process() {
  local state="$1" pane="${2//:/_}" pid="$3" name="$4"
  print -r -- '{"result":{"process_info":{"foreground_process_group_id":'"$pid"',"foreground_processes":[{"name":"'"$name"'","pid":'"$pid"'}]}}}' \
    >"$state/process-$pane.json"
}

new_state() {
  local state
  state="$(mktemp -d "$tmp_root/state.XXXXXX")"
  : >"$state/calls"
  print -- "$state"
}

run_helper() {
  local state="$1" file="$2"
  shift 2
  env PATH="$test_dir/bin:$PATH" FAKE_HERDR_STATE="$state" HERDR_ENV=1 \
    HERDR_WORKSPACE_ID=w1 HERDR_TAB_ID=w1:t1 HERDR_PANE_ID=w1:p1 "$@" zsh "$helper" "$file"
}

test_reuses_editor() {
  local state file output calls command
  state="$(new_state)"
  file="$tmp_root/target space's ü.md"
  : >"$file"
  print -r -- '{"result":{"panes":[{"tab_id":"w1:t1","pane_id":"w1:p1"},{"tab_id":"w1:t1","pane_id":"w1:p2"}]}}' >"$state/panes.json"
  write_process "$state" w1:p1 101 zsh
  write_process "$state" w1:p2 202 nvim

  output="$(run_helper "$state" "$file")"
  [[ $output == 'opened multiplexer=herdr pane=w1:p2 pid=202 created=false' ]] || fail "$output"
  calls="$(<$state/calls)"
  command="$(<$state/sent-text)"
  assert_contains "$calls" 'pane list --workspace w1'
  assert_contains "$calls" 'pane send-keys w1:p2 Escape ctrl+backslash ctrl+n'
  assert_contains "$calls" 'pane send-text w1:p2'
  assert_contains "$calls" 'pane send-keys w1:p2 Enter'
  [[ $calls != *'pane run'* ]] || fail 'used pane run for editor input'
  assert_contains "$command" ':execute '\''tabedit '\'' . fnameescape('
  [[ $command != *'edit!'* ]] || fail 'used edit!'
}

test_creates_editor_in_current_tab() {
  local state file output calls
  state="$(new_state)"
  file="$tmp_root/create.md"
  : >"$file"
  print -r -- '{"result":{"panes":[{"tab_id":"w1:t1","pane_id":"w1:p1"},{"tab_id":"w1:t9","pane_id":"w1:p9"}]}}' >"$state/panes.json"
  write_process "$state" w1:p1 101 zsh
  write_process "$state" w1:p9 909 nvim

  output="$(run_helper "$state" "$file")"
  [[ $output == 'opened multiplexer=herdr pane=w1:pnew created=true' ]] || fail "$output"
  calls="$(<$state/calls)"
  [[ $calls != *'w1:p9'* ]] || fail 'queried another tab'
  assert_contains "$calls" 'pane split w1:p1 --direction right'
  assert_contains "$calls" 'pane run w1:pnew exec nvim'
}

test_rejects_ambiguity_and_failures() {
  local state file output exit_status
  file="$tmp_root/error.md"
  : >"$file"

  state="$(new_state)"
  print -r -- '{"result":{"panes":[{"tab_id":"w1:t1","pane_id":"w1:p2"},{"tab_id":"w1:t1","pane_id":"w1:p3"}]}}' >"$state/panes.json"
  write_process "$state" w1:p2 202 nvim
  write_process "$state" w1:p3 303 vim
  set +e
  output="$(run_helper "$state" "$file" 2>&1)"
  exit_status=$?
  set -e
  [[ $exit_status == 3 && $output == *'ambiguous-editors'* ]] || fail 'ambiguity did not fail'

  state="$(new_state)"
  print -r -- '{"result":{"panes":[{"tab_id":"w1:t1","pane_id":"w1:p2"}]}}' >"$state/panes.json"
  write_process "$state" w1:p2 202 nvim
  set +e
  output="$(run_helper "$state" "$file" FAKE_HERDR_FAIL_SEND=1 2>&1)"
  exit_status=$?
  set -e
  ((exit_status != 0)) || fail 'send failure reported success'
  [[ $output != *'opened'* ]] || fail 'send failure printed opened'
}

foreground_nvim_pid() {
  local tty="$1"
  ps -o pid=,tpgid=,comm= -t "${tty#/dev/}" | while read -r pid tpgid command; do
    [[ $pid == "$tpgid" && ${command:t} == nvim ]] && print -- "$pid"
  done
}

wait_for_file() {
  local file="$1"
  for _ in {1..100}; do
    [[ -s $file ]] && return 0
    sleep 0.01
  done
  return 1
}

test_tmux_preserves_modified_buffer() {
  command -v tmux >/dev/null && command -v nvim >/dev/null || return 0

  local dir source target inspect pane tty pid output inspect_command
  dir="$tmp_root/tmux"
  mkdir -p "$dir/bin"
  source="$dir/source.ex"
  target="$dir/target space's ü.md"
  inspect="$dir/inspect"
  print -r -- 'ORIGINAL' >"$source"
  : >"$target"
  tmux -L "$tmux_socket" new-session -d -s test -x 120 -y 30 "exec nvim --clean ${(q)source}"
  pane="$(tmux -L "$tmux_socket" display-message -p -t test:0.0 '#{pane_id}')"
  sleep 0.1
  tty="$(tmux -L "$tmux_socket" display-message -p -t "$pane" '#{pane_tty}')"
  pid="$(foreground_nvim_pid "$tty")"
  tmux -L "$tmux_socket" send-keys -t "$pane" G A __UNSAVED_SENTINEL

  print -r -- '#!/bin/sh' >"$dir/bin/tmux"
  print -r -- "exec ${(q)commands[tmux]} -L ${(q)tmux_socket} \"\$@\"" >>"$dir/bin/tmux"
  chmod +x "$dir/bin/tmux"
  output="$(env PATH="$dir/bin:$PATH" HERDR_ENV=0 TMUX=x TMUX_PANE="$pane" zsh "$helper" "$target")"
  assert_contains "$output" "opened multiplexer=tmux pane=$pane"

  inspect_command=":call writefile([expand('%:p'), string(getbufvar(bufnr('${source//\'/\'\'}'), '&modified'))] + getbufline(bufnr('${source//\'/\'\'}'), 1, '\$'), '${inspect//\'/\'\'}', 'b')"
  tmux -L "$tmux_socket" send-keys -t "$pane" Escape
  tmux -L "$tmux_socket" send-keys -l -t "$pane" "$inspect_command"
  tmux -L "$tmux_socket" send-keys -t "$pane" Enter
  wait_for_file "$inspect" || fail 'inspection timed out'
  inspection=("${(@f)$(<$inspect)}")
  [[ ${inspection[1]} == "$target" ]] || fail 'target not open'
  [[ ${inspection[2]} == 1 ]] || fail 'source no longer modified'
  [[ ${inspection[3]} == 'ORIGINAL__UNSAVED_SENTINEL' ]] || fail 'source buffer changed'
  [[ $(foreground_nvim_pid "$tty") == "$pid" ]] || fail 'Neovim PID changed'
}

test_reuses_editor
test_creates_editor_in_current_tab
test_rejects_ambiguity_and_failures
test_tmux_preserves_modified_buffer
print -- 'ok: open_in_nvim tests passed'
