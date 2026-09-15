#!/usr/bin/env bash
set -euo pipefail

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
repair_script="$config_home/nvim/mason-reinstall-python-packages.lua"
python_tool_regex='"name"[[:space:]]*:[[:space:]]*"python"'

if [[ ! ${MISE_INSTALLED_TOOLS:-} =~ $python_tool_regex ]]; then
  exit 0
fi

if ! command -v nvim >/dev/null || [[ ! -d "$data_home/nvim/lazy/mason.nvim" ]]; then
  exit 0
fi

MASON_REPAIR_SCRIPT="$repair_script" \
  DOTFILES_SKIP_MASON_AUTOINSTALL=1 \
  nvim --headless '+lua dofile(vim.env.MASON_REPAIR_SCRIPT)'
