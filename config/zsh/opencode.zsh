# pin opencode path to mise shim so that littlesnitch rules stick
alias opencode="$HOME/.local/share/mise/shims/opencode"

function opencode2() {
  OPENCODE_DB="${XDG_DATA_HOME:-$HOME/.local/share}/opencode/opencode-next.db" command opencode2 "$@"
}
