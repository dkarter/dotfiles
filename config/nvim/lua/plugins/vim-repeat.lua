-- allow (non-native) plugins to the . command
---@type LazySpec
return { 'tpope/vim-repeat', event = { 'BufReadPost', 'BufNewFile' } }
