-- Support emacs keybindings in insert mode
---@type LazySpec
return { 'tpope/vim-rsi', event = { 'BufReadPost', 'BufNewFile' } }
