-- Support emacs keybindings in insert mode
return { 'tpope/vim-rsi', event = { 'BufReadPost', 'BufNewFile' } }
