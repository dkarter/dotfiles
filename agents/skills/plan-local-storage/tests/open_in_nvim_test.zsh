#!/usr/bin/env zsh
set -euo pipefail

script_dir="${0:A:h}"
helper="${script_dir:h}/scripts/open_in_nvim.zsh"
fake_bin="$script_dir/bin"
tmp_root="$(mktemp -d "${TMPDIR:-/tmp}/open-in-nvim-test.XXXXXX")"
trap 'tmux -L "$tmux_socket" kill-server 2>/dev/null || true; rm -rf "$tmp_root"' EXIT

tests_run=0
tmux_socket="open-in-nvim-test-$$"

fail() {
  print -u2 -- "not ok: $1"
  exit 1
}

assert_contains() {
  print -r -- "$1" | grep -F -- "$2" >/dev/null || fail "expected <$2> in <$1>"
}

assert_not_contains() {
  if print -r -- "$1" | grep -F -- "$2" >/dev/null; then
    fail "did not expect <$2> in <$1>"
  fi
}

write_process() {
  local state_dir="$1"
  local pane_key="${2//:/_}"
  local pid="$3"
  local name="$4"
  local suffix="${5:-}"
  print -r -- '{"result":{"process_info":{"foreground_process_group_id":'"$pid"',"foreground_processes":[{"name":"'"$name"'","pid":'"$pid"'}]}}}' \
    >"$state_dir/process-$pane_key$suffix.json"
}

run_fake_helper() {
  local state_dir="$1"
  local target_file="$2"
  shift 2
  env PATH="$fake_bin:$PATH" FAKE_HERDR_STATE="$state_dir" HERDR_ENV=1 HERDR_WORKSPACE_ID=w1 HERDR_TAB_ID=w1:t1 HERDR_PANE_ID=w1:p1 \
    "$@" zsh "$helper" "$target_file"
}

new_state() {
  local state_dir
  state_dir="$(mktemp -d "$tmp_root/state.XXXXXX")"
  : >"$state_dir/calls"
  print -- "$state_dir"
}

test_verified_herdr_handoff() {
  local state_dir target_file output calls sent_text
  state_dir="$(new_state)"
  target_file="$tmp_root/target space's ü;\$|.md"
  : >"$target_file"
  print -r -- '{"result":{"panes":[{"workspace_id":"w1","tab_id":"w1:t1","pane_id":"w1:p1"},{"workspace_id":"w1","tab_id":"w1:t1","pane_id":"w1:p2"}]}}' >"$state_dir/panes.json"
  write_process "$state_dir" w1:p1 101 zsh
  write_process "$state_dir" w1:p2 202 nvim

  output="$(run_fake_helper "$state_dir" "$target_file")"
  assert_contains "$output" 'opened multiplexer=herdr pane=w1:p2 pid=202 created=false lookup_commands=3 commands=7'
  calls="$(<$state_dir/calls)"
  [[ $(wc -l <"$state_dir/calls" | tr -d ' ') == 7 ]] || fail 'unexpected successful Herdr command count'
  sent_text="$(<$state_dir/sent-text)"
  assert_contains "$calls" 'pane list --workspace w1'
  assert_contains "$calls" 'pane send-keys w1:p2 Escape'
  assert_contains "$calls" 'pane send-text w1:p2'
  assert_contains "$calls" 'pane send-keys w1:p2 Enter'
  assert_not_contains "$calls" 'pane run'
  assert_contains "$sent_text" ':execute '\''tabedit '\'' . fnameescape('
  assert_contains "$sent_text" 'fnameescape("'
  assert_not_contains "$sent_text" 'edit!'
  ((++tests_run))
}

test_no_editor_creates_in_current_tab() {
  local state_dir target_file output calls
  state_dir="$(new_state)"
  target_file="$tmp_root/no-editor.md"
  : >"$target_file"
  print -r -- '{"result":{"panes":[{"workspace_id":"w1","tab_id":"w1:t1","pane_id":"w1:p1"},{"workspace_id":"w1","tab_id":"w1:t9","pane_id":"w1:p9"},{"workspace_id":"w9","tab_id":"w9:t1","pane_id":"w9:p1"}]}}' >"$state_dir/panes.json"
  write_process "$state_dir" w1:p1 101 zsh
  write_process "$state_dir" w1:p9 909 nvim
  write_process "$state_dir" w9:p1 919 nvim
  write_process "$state_dir" w1:pnew 707 nvim

  output="$(run_fake_helper "$state_dir" "$target_file")"
  assert_contains "$output" 'opened multiplexer=herdr pane=w1:pnew pid=707 created=true lookup_commands=2 commands=5'
  calls="$(<$state_dir/calls)"
  [[ $(wc -l <"$state_dir/calls" | tr -d ' ') == 5 ]] || fail 'unexpected create command count'
  assert_not_contains "$calls" 'w1:p9'
  assert_not_contains "$calls" 'w9:p1'
  assert_contains "$calls" 'pane split w1:p1 --direction right'
  assert_contains "$calls" 'pane run w1:pnew exec nvim'
  ((++tests_run))
}

test_missing_pane_id_uses_one_context_query() {
  local state_dir target_file output calls current_query_count
  state_dir="$(new_state)"
  target_file="$tmp_root/context-query.md"
  : >"$target_file"
  print -r -- '{"result":{"panes":[{"workspace_id":"w1","tab_id":"w1:t1","pane_id":"w1:p1"}]}}' >"$state_dir/panes.json"
  write_process "$state_dir" w1:p1 101 zsh
  write_process "$state_dir" w1:pnew 707 nvim

  output="$(run_fake_helper "$state_dir" "$target_file" HERDR_PANE_ID=)"
  assert_contains "$output" 'opened multiplexer=herdr pane=w1:pnew pid=707 created=true lookup_commands=3 commands=6'
  calls="$(<$state_dir/calls)"
  [[ $(wc -l <"$state_dir/calls" | tr -d ' ') == 6 ]] || fail 'unexpected fallback context command count'
  current_query_count="$(print -r -- "$calls" | grep -F -c -- 'pane current --current')"
  [[ $current_query_count == 1 ]] || fail 'expected exactly one current-pane query'
  ((++tests_run))
}

test_ambiguous_editors_fail() {
  local state_dir target_file output exit_status
  state_dir="$(new_state)"
  target_file="$tmp_root/ambiguous.md"
  : >"$target_file"
  print -r -- '{"result":{"panes":[{"workspace_id":"w1","tab_id":"w1:t1","pane_id":"w1:p2"},{"workspace_id":"w1","tab_id":"w1:t1","pane_id":"w1:p3"}]}}' >"$state_dir/panes.json"
  write_process "$state_dir" w1:p2 202 nvim
  write_process "$state_dir" w1:p3 303 vim

  set +e
  output="$(run_fake_helper "$state_dir" "$target_file" 2>&1)"
  exit_status=$?
  set -e
  [[ $exit_status == 3 ]] || fail "ambiguous editors returned $exit_status"
  assert_contains "$output" 'error reason=ambiguous-editors multiplexer=herdr panes=w1:p2,w1:p3'
  assert_not_contains "$output" 'opened'
  ((++tests_run))
}

test_failures_never_report_success() {
  local failure state_dir target_file output exit_status
  target_file="$tmp_root/failure.md"
  : >"$target_file"

  for failure in send-text; do
    state_dir="$(new_state)"
    print -r -- '{"result":{"panes":[{"workspace_id":"w1","tab_id":"w1:t1","pane_id":"w1:p2"}]}}' >"$state_dir/panes.json"
    write_process "$state_dir" w1:p2 202 nvim
    set +e
    output="$(run_fake_helper "$state_dir" "$target_file" FAKE_HERDR_FAIL_COMMAND="$failure" 2>&1)"
    exit_status=$?
    set -e
    ((exit_status != 0)) || fail "$failure unexpectedly succeeded"
    assert_contains "$output" 'error reason=command-failed command=herdr-send-text status=41'
    assert_not_contains "$output" 'opened'
  done

  state_dir="$(new_state)"
  print -r -- '{"result":{"panes":[{"workspace_id":"w1","tab_id":"w1:t1","pane_id":"w1:p2"}]}}' >"$state_dir/panes.json"
  write_process "$state_dir" w1:p2 202 nvim
  set +e
  output="$(run_fake_helper "$state_dir" "$target_file" FAKE_HERDR_SKIP_ACK=1 OPEN_IN_NVIM_VERIFY_TIMEOUT_MS=10 2>&1)"
  exit_status=$?
  set -e
  [[ $exit_status == 4 ]] || fail "missing acknowledgement returned $exit_status"
  assert_contains "$output" 'error reason=target-not-verified'
  assert_not_contains "$output" 'opened'

  state_dir="$(new_state)"
  print -r -- '{"result":{"panes":[{"workspace_id":"w1","tab_id":"w1:t1","pane_id":"w1:p2"}]}}' >"$state_dir/panes.json"
  write_process "$state_dir" w1:p2 202 nvim
  write_process "$state_dir" w1:p2 999 nvim -after
  set +e
  output="$(run_fake_helper "$state_dir" "$target_file" 2>&1)"
  exit_status=$?
  set -e
  [[ $exit_status == 4 ]] || fail "changed process returned $exit_status"
  assert_contains "$output" 'error reason=editor-process-changed'
  assert_not_contains "$output" 'opened'

  state_dir="$(new_state)"
  print -r -- '{"result":{"panes":[{"workspace_id":"w1","tab_id":"w1:t1","pane_id":"w1:p1"}]}}' >"$state_dir/panes.json"
  write_process "$state_dir" w1:p1 101 zsh
  write_process "$state_dir" w1:pnew 707 nvim
  set +e
  output="$(run_fake_helper "$state_dir" "$target_file" FAKE_HERDR_SKIP_ACK=1 OPEN_IN_NVIM_LAUNCH_TIMEOUT_MS=10 2>&1)"
  exit_status=$?
  set -e
  [[ $exit_status == 4 ]] || fail "failed creation returned $exit_status"
  assert_contains "$output" 'error reason=target-not-verified multiplexer=herdr pane=w1:pnew created=true'
  assert_contains "$(<$state_dir/calls)" 'pane close w1:pnew'
  assert_not_contains "$output" 'opened'
  ((++tests_run))
}

foreground_pid_for_tty() {
  local tty="$1"
  ps -o pid=,tpgid=,comm= -t "${tty#/dev/}" | while read -r pid tpgid command; do
    if [[ $pid == "$tpgid" && ${command:t} == nvim ]]; then
      print -- "$pid"
      return 0
    fi
  done
  return 1
}

wait_for_nvim() {
  local pane="$1"
  local attempt command
  for attempt in {1..100}; do
    command="$(tmux -L "$tmux_socket" display-message -p -t "$pane" '#{pane_current_command}')"
    [[ $command == nvim ]] && return 0
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

test_isolated_tmux_neovim() {
  if ! command -v tmux >/dev/null || ! command -v nvim >/dev/null; then
    print -- 'ok: isolated tmux/neovim integration skipped (dependency unavailable)'
    return 0
  fi

  local integration_dir source_file target_file normal_target terminal_target inspect_file pane pane_tty pid_before pid_after output expected command exit_status
  integration_dir="$tmp_root/integration"
  mkdir -p "$integration_dir/bin"
  source_file="$integration_dir/source.elixir"
  target_file="$integration_dir/target space's ü.md"
  normal_target="$integration_dir/normal-mode.md"
  terminal_target="$integration_dir/terminal-mode.md"
  inspect_file="$integration_dir/inspect.txt"
  print -r -- 'ORIGINAL' >"$source_file"
  print -r -- 'TARGET' >"$target_file"
  print -r -- 'NORMAL' >"$normal_target"
  print -r -- 'TERMINAL' >"$terminal_target"

  tmux -L "$tmux_socket" new-session -d -s isolated -x 120 -y 30 "exec nvim --clean ${(q)source_file}"
  pane="$(tmux -L "$tmux_socket" display-message -p -t isolated:0.0 '#{pane_id}')"
  wait_for_nvim "$pane" || fail 'isolated Neovim did not start'
  pane_tty="$(tmux -L "$tmux_socket" display-message -p -t "$pane" '#{pane_tty}')"
  pid_before="$(foreground_pid_for_tty "$pane_tty")"

  tmux -L "$tmux_socket" send-keys -t "$pane" 'G' 'A' '__UNSAVED_INSERT_SENTINEL'

  print -r -- '#!/bin/sh' >"$integration_dir/bin/tmux"
  print -r -- "exec ${(q)commands[tmux]} -L ${(q)tmux_socket} \"\$@\"" >>"$integration_dir/bin/tmux"
  chmod +x "$integration_dir/bin/tmux"

  set +e
  output="$(env PATH="$integration_dir/bin:$PATH" HERDR_ENV=0 TMUX="isolated,$$,0" TMUX_PANE="$pane" zsh "$helper" "$target_file")"
  exit_status=$?
  set -e
  if ((exit_status != 0)); then
    tmux -L "$tmux_socket" capture-pane -p -t "$pane" -S -20 >&2
    fail "tmux helper returned $exit_status"
  fi
  assert_contains "$output" "opened multiplexer=tmux pane=$pane pid=$pid_before"
  pid_after="$(foreground_pid_for_tty "$pane_tty")"
  [[ $pid_after == "$pid_before" ]] || fail 'Neovim PID changed'

  command=":call writefile([expand('%:p'), string(getbufvar(bufnr('${source_file//\'/\'\'}'), '&modified'))] + getbufline(bufnr('${source_file//\'/\'\'}'), 1, '\$'), '${inspect_file//\'/\'\'}', 'b')"
  tmux -L "$tmux_socket" send-keys -t "$pane" Escape
  tmux -L "$tmux_socket" send-keys -l -t "$pane" "$command"
  tmux -L "$tmux_socket" send-keys -t "$pane" Enter
  wait_for_file "$inspect_file" || fail 'Neovim inspection did not complete'

  local -a inspection
  inspection=("${(@f)$(<$inspect_file)}")
  [[ ${inspection[1]} == "$target_file" ]] || fail 'requested target is not visible'
  [[ ${inspection[2]} == 1 ]] || fail 'source buffer is no longer modified'
  expected='ORIGINAL__UNSAVED_INSERT_SENTINEL'
  [[ ${inspection[3]} == "$expected" ]] || fail "source buffer changed: ${inspection[3]}"
  assert_not_contains "${inspection[3]}" ':execute '\''tabedit'

  output="$(env PATH="$integration_dir/bin:$PATH" HERDR_ENV=0 TMUX="isolated,$$,0" TMUX_PANE="$pane" zsh "$helper" "$normal_target")"
  assert_contains "$output" "opened multiplexer=tmux pane=$pane pid=$pid_before"
  rm -f "$inspect_file"
  command=":call writefile([expand('%:p')], '${inspect_file//\'/\'\'}', 'b')"
  tmux -L "$tmux_socket" send-keys -t "$pane" Escape
  tmux -L "$tmux_socket" send-keys -l -t "$pane" "$command"
  tmux -L "$tmux_socket" send-keys -t "$pane" Enter
  wait_for_file "$inspect_file" || fail 'normal-mode inspection did not complete'
  [[ $(<$inspect_file) == "$normal_target" ]] || fail 'normal-mode target is not visible'
  [[ $(foreground_pid_for_tty "$pane_tty") == "$pid_before" ]] || fail 'Neovim PID changed after normal-mode open'

  tmux -L "$tmux_socket" send-keys -t "$pane" Escape
  tmux -L "$tmux_socket" send-keys -l -t "$pane" ':terminal cat'
  tmux -L "$tmux_socket" send-keys -t "$pane" Enter i
  output="$(env PATH="$integration_dir/bin:$PATH" HERDR_ENV=0 TMUX="isolated,$$,0" TMUX_PANE="$pane" zsh "$helper" "$terminal_target")"
  assert_contains "$output" "opened multiplexer=tmux pane=$pane pid=$pid_before"
  rm -f "$inspect_file"
  command=":call writefile([expand('%:p')], '${inspect_file//\'/\'\'}', 'b')"
  tmux -L "$tmux_socket" send-keys -t "$pane" Escape 'C-\' C-n
  tmux -L "$tmux_socket" send-keys -l -t "$pane" "$command"
  tmux -L "$tmux_socket" send-keys -t "$pane" Enter
  wait_for_file "$inspect_file" || fail 'terminal-mode inspection did not complete'
  [[ $(<$inspect_file) == "$terminal_target" ]] || fail 'terminal-mode target is not visible'
  [[ $(foreground_pid_for_tty "$pane_tty") == "$pid_before" ]] || fail 'Neovim PID changed after terminal-mode open'

  ((++tests_run))
  tmux -L "$tmux_socket" kill-server
}

test_verified_herdr_handoff
test_no_editor_creates_in_current_tab
test_missing_pane_id_uses_one_context_query
test_ambiguous_editors_fail
test_failures_never_report_success
test_isolated_tmux_neovim

print -- "ok: $tests_run open_in_nvim tests passed"
