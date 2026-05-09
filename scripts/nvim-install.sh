#!/usr/bin/env bash
set -euo pipefail

case "$(uname -m)" in
  aarch64 | arm64)
    export MISE_DISABLE_TOOLS='resvg,github:mazznoer/lolcrab'
    ;;
esac

DOTFILES_SKIP_MASON_AUTOINSTALL=1 mise exec -- nvim --headless \
  +'Lazy! restore' \
  +'Lazy! clean' \
  +'qall'

DOTFILES_SKIP_MASON_AUTOINSTALL=1 mise exec -- nvim --headless \
  +'luafile scripts/nvim-install-mason.lua'
