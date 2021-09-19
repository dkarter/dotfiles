TARGET_DIR="$HOME/.elixir_ls"

# Cleanup (making the script idempotent)
rm -rf "$TARGET_DIR"

git clone https://github.com/elixir-lsp/elixir-ls.git "$TARGET_DIR"

cd "$TARGET_DIR"

mix deps.get
mix elixir_ls.release

