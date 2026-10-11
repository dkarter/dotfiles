#!/bin/sh
set -eu

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

merge_hooks() {
  destination=$1
  mkdir -p "${destination%/*}"
  if ! [ -e "$destination" ]; then
    printf '{}\n' >"$destination"
    chmod 600 "$destination"
  fi
  # Update the target rather than replacing an existing settings symlink.
  destination=$(realpath "$destination")
  temporary=$(mktemp "${destination%/*}/.inline-command.XXXXXX")
  trap 'trash "$temporary"' EXIT HUP INT TERM
  chmod 600 "$temporary"
  jq --slurpfile inline "$script_dir/hooks.json" '
    # Retire only the old workmux status commands, preserving all other hooks.
    .hooks = ((.hooks // {}) | with_entries(
      .value |= map(
        .hooks |= map(select((.command // "" | test("^workmux set-window-status (working|waiting|done)$")) | not))
        | select(.hooks | length > 0)
      ) | select(.value | length > 0)
    ))
    |
    .hooks.UserPromptSubmit = (
      ((.hooks.UserPromptSubmit // []) | map(
        .hooks |= map(select((.command // "" | contains("inline-command/hook.ts")) | not))
        | select(.hooks | length > 0)
      )) + $inline[0].hooks.UserPromptSubmit
    )
  ' "$destination" >"$temporary"
  jq -e '.hooks.UserPromptSubmit | type == "array"' "$temporary" >/dev/null
  mv "$temporary" "$destination"
  trap - EXIT HUP INT TERM
}

merge_hooks "$HOME/.claude/settings.json"
merge_hooks "$HOME/.codex/hooks.json"

# Claude mods can rewrite the actual prompt; keep the command hook as fallback.
# Its parser finds no unexpanded commands once the mod has rewritten the text.
destination=$(realpath "$HOME/.claude/settings.json")
temporary=$(mktemp "${destination%/*}/.inline-command.XXXXXX")
trap 'trash "$temporary"' EXIT HUP INT TERM
chmod 600 "$temporary"
jq --arg mod "$script_dir/claude" '
  .env.CLAUDE_CODE_PLUGIN_DIRS = (
    ((.env.CLAUDE_CODE_PLUGIN_DIRS // "") | split(":")) + [$mod]
    | map(select(length > 0)) | unique | join(":")
  )
' "$destination" >"$temporary"
mv "$temporary" "$destination"
trap - EXIT HUP INT TERM
