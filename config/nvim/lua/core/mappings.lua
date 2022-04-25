local utils = require 'utils'
local nmap = utils.nmap
local vmap = utils.vmap

-- -- set leader key to `\`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'
vim.cmd [[nmap <space> \]]
vim.cmd [[xmap <space> \]]
-- TODO: find out why this doesn't work with helper funcs or why I can't just
-- set the leader to space directly
-- alias for leader key (use space as leader)

-- center window on search result
nmap { 'n', 'nzzzv' }
nmap { 'N', 'Nzzzv' }

--  close tab
nmap { '<c-w>w', ':bd<CR>' }

-- rename current file
nmap { '<Leader>rn', ":Move <C-R>=expand('%')<CR>" }

-- sort selected lines
vmap { 'gs', ':sort<CR>' }

-- remove highlighting on escape
nmap { '<esc>', ':nohlsearch<cr>', { silent = true } }
