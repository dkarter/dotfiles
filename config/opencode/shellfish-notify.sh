#!/bin/sh
# shellfish-notify - Secure ShellFish hook helper for agentic coding hooks.
#
# Reads a hook JSON payload on stdin and forwards it to ShellFish through an
# OSC sequence on the controlling terminal. OpenCode uses OSC 777 for custom
# notification text; other tools use the ShellFish OSC 6 agent integration.
# Notifications are silent when ShellFish is already in the foreground.
#
# The Shell Integration installer can wire this up for you — re-run Install
# from the app and pick "Install" when prompted. To do it by hand, add a
# hook to ~/.claude/settings.json using the absolute path (Claude Code does
# not expand ~ or $HOME inside hook commands):
#
#   "hooks": {
#     "Notification": [{"hooks":[{"type":"command",
#       "command":"/Users/you/.claude/shellfish-notify.sh claude"}]}],
#     "Stop": [{"hooks":[{"type":"command",
#       "command":"/Users/you/.claude/shellfish-notify.sh claude"}]}]
#   }
#
# Codex CLI and OpenCode use equivalent hook syntax — pass the matching tool
# name as the first argument (codex, opencode, etc.).

tool="${1:-agent}"
hook=$(cat)

if [ "$tool" = "opencode" ]; then
  osc="777;notify;OpenCode;finished"
else
  tool_b64=$(printf '%s' "$tool" | base64 | tr -d '\n')
  hook_b64=$(printf '%s' "$hook" | base64 | tr -d '\n')
  osc="6;codingagenthook://?ver=2&tool=${tool_b64}&hook=${hook_b64}"
fi

# Herdr renders pane PTYs itself and does not forward arbitrary OSC sequences.
# Send directly to each attached Herdr client's outer terminal instead.
if [ "${HERDR_ENV:-}" = "1" ] && command -v pgrep >/dev/null 2>&1; then
  delivered=false
  for client_pid in $(pgrep -x herdr 2>/dev/null); do
    client_command=$(ps -o command= -p "$client_pid" 2>/dev/null)
    case "$client_command" in
      herdr | */herdr)
        client_tty=$(ps -o tty= -p "$client_pid" 2>/dev/null | tr -d ' ')
        case "$client_tty" in
          ttys* | ttyp* | pts*)
            marker="$HOME/.cache/shellfish/ttys/$client_tty"
            registered=false
            if [ -r "$marker" ]; then
              while IFS= read -r shell_pid; do
                shell_tty=$(ps -o tty= -p "$shell_pid" 2>/dev/null | tr -d ' ')
                if [ "$shell_tty" = "$client_tty" ]; then
                  registered=true
                  break
                fi
              done <"$marker"
            fi
            if $registered; then
              printf '\033]%s\a' "$osc" >"/dev/$client_tty" 2>/dev/null && delivered=true
            fi
            ;;
        esac
        ;;
    esac
  done
  $delivered && exit 0
  exit 0
fi

[ "${LC_TERMINAL:-}" = "ShellFish" ] || exit 0

# /dev/tty only works when this process has a controlling terminal, which
# agent hook subprocesses (Claude Code, Codex, OpenCode) usually do not.
# The write then fails with "device not configured" and the notification is
# silently lost. Walk up the process tree to the shell or agent that owns the
# ShellFish pty (the tmux pane pty when inside tmux) and write there instead.
# Fall back to $SSH_TTY, then /dev/tty.
tty_path=""
pid=$$
i=0
while [ -n "$pid" ] && [ "$pid" -gt 1 ] && [ "$i" -lt 12 ]; do
  t=$(ps -o tty= -p "$pid" 2>/dev/null | tr -d ' ')
  case "$t" in ttys* | ttyp* | pts*)
    tty_path="/dev/$t"
    break
    ;;
  esac
  pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
  i=$((i + 1))
done
[ -z "$tty_path" ] && tty_path="${SSH_TTY:-/dev/tty}"

# stdout is a pipe to the agent process, which would swallow the escape, so
# write to the resolved terminal. Inside tmux the OSC is wrapped in a
# passthrough so it reaches the outer terminal (needs allow-passthrough on).
if [ -n "$TMUX" ]; then
  printf '\033Ptmux;\033\033]%s\a\033\134' "$osc" >"$tty_path" 2>/dev/null || true
else
  printf '\033]%s\a' "$osc" >"$tty_path" 2>/dev/null || true
fi
