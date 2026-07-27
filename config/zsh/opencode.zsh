# Bypass aube's shim, which currently launches OpenCode's native .exe with Node.
# `opencode.exe` is a compiled Mach-O/ELF binary, not JavaScript, so running it
# through `node` fails with "SyntaxError: Invalid or unexpected token". Exec the
# binary directly instead. See taskfiles/completions.yml for the same workaround
# applied to shell completions.
opencode() {
  if [[ -z $_OPENCODE_BIN ]]; then
    _OPENCODE_BIN="$(mise where npm:opencode-ai 2>/dev/null)/node_modules/opencode-ai/bin/opencode.exe"
  fi
  if [[ -x $_OPENCODE_BIN ]]; then
    "$_OPENCODE_BIN" "$@"
  else
    command opencode "$@"
  fi
}
