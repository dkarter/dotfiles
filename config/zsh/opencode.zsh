# pin opencode path to mise shim so that littlesnitch rules stick
alias opencode="$HOME/.local/share/mise/shims/opencode"

function opencode2() {
  local database="${XDG_DATA_HOME:-$HOME/.local/share}/opencode/opencode.db"

  if (($# == 0)) || [[ $1 == -* || -d $1 ]]; then
    OPENCODE_DB="$database" command opencode2 --standalone "$@"
  else
    OPENCODE_DB="$database" command opencode2 "$@"
  fi
}
