#!/bin/sh
set -eu

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

install_link() {
  source=$1
  destination=$2

  mkdir -p "${destination%/*}"
  if [ -e "$destination" ] || [ -L "$destination" ]; then
    source_target=$(realpath "$source")
    destination_target=$(realpath "$destination" 2>/dev/null || true)
    if [ "$destination_target" != "$source_target" ]; then
      printf 'Refusing to replace %s\n' "$destination" >&2
      exit 1
    fi
    return
  fi
  ln -s "$source" "$destination"
}

merge_hooks() {
  destination=$1
  source=$2

  mkdir -p "${destination%/*}"
  if ! [ -e "$destination" ]; then
    printf '{}\n' >"$destination"
    chmod 600 "$destination"
  fi

  temporary=$(mktemp "${destination%/*}/.credential-guard.XXXXXX")
  trap 'rm -f "$temporary"' EXIT HUP INT TERM
  chmod 600 "$temporary"
  jq --slurpfile guard "$source" '
    (.hooks // {}) as $hooks
    | .hooks = ($hooks | with_entries(
        .value |= map(select(
          ([.hooks[]?.command // ""] | any(contains("agent-guard/hook.ts"))) | not
        ))
      ))
    | .hooks.PostToolUse = (
        (.hooks.PostToolUse // []) + $guard[0].hooks.PostToolUse | unique_by(tostring)
      )
  ' "$destination" >"$temporary"
  jq -e 'type == "object" and (.hooks.PostToolUse | type == "array")' "$temporary" >/dev/null
  mv "$temporary" "$destination"
  trap - EXIT HUP INT TERM
}

install_link "$script_dir" "$HOME/.config/agent-guard"
install_link "$script_dir/../amp/plugins/credential-guard.ts" "$HOME/.config/amp/plugins/credential-guard.ts"
merge_hooks "$HOME/.claude/settings.json" "$script_dir/claude-hooks.json"
merge_hooks "$HOME/.codex/hooks.json" "$script_dir/codex-hooks.json"
