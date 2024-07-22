-- automatically adjusts 'shiftwidth' and 'expandtab' heuristically
return { 'tpope/vim-sleuth', event = { 'BufReadPre', 'BufNewFile' } }
