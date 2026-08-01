#!/usr/bin/env bash
set -euo pipefail

mise exec -- nvim \
  --headless \
  +verbose \
  +'Lazy! sync' \
  +'Lazy! clean' \
  +'Lazy! clear' \
  +"lua assert(require('nvim-treesitter').update():wait(300000), 'failed to update Tree-sitter parsers')" \
  +'autocmd User MasonUpdateAllCompleted qall!' \
  +'MasonUpdateAll'
