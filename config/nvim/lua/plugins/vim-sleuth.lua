-- automatically adjusts 'shiftwidth' and 'expandtab' heuristically
---@type LazySpec
return { 'tpope/vim-sleuth', event = { 'BufReadPre', 'BufNewFile' } }
