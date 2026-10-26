#!/bin/sh

set -eu

# No branch-name guessing or API calls for unassigned worktrees.
ticket="${HWT_TICKET_IDENTIFIER:-}"
[ -n "$ticket" ] || exit 0
[ -t 0 ] && [ -t 2 ] || exit 0

# Herdr panes can retain version-specific tool paths after a Mise upgrade.
export PATH="$HOME/.local/share/mise/shims:$PATH"
for tool in git lnr jq; do
  command -v "$tool" >/dev/null 2>&1 || exit 0
done

# Global dotfiles also run on personal machines and in personal repositories.
remote="$(git config --get remote.origin.url 2>/dev/null)" || exit 0
case "$remote" in
  git@github.com:pdq/* | https://github.com/pdq/* | ssh://git@github.com/pdq/*) ;;
  *) exit 0 ;;
esac

warn() {
  printf 'HWT: %s; continuing worktree removal.\n' "$1" >&2
}

# issue get never opens a picker or starts browser login.
if ! issue="$(lnr issue get "$ticket" --json)"; then
  warn "could not check ticket status"
  exit 0
fi

# Refuse unexpected/mismatched output rather than offering to change a ticket.
if ! state="$(printf '%s' "$issue" | jq -er --arg ticket "$ticket" \
  'select(.issueId == $ticket) | .status.type | select(type == "string")')"; then
  warn "could not read ticket status"
  exit 0
fi
case "$state" in
  completed | canceled) exit 0 ;;
  triage | backlog | unstarted | started) ;;
  *)
    warn "unrecognized ticket status"
    exit 0
    ;;
esac

printf 'Mark %s as Done too? [y/N] ' "$ticket" >&2
IFS= read -r answer || exit 0
case "$answer" in
  y | Y | yes | YES | Yes)
    if ! lnr issue update "$ticket" --status Done --json >/dev/null; then
      warn "could not mark ticket as Done"
    fi
    ;;
esac

exit 0
