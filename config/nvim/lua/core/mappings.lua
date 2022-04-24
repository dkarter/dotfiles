local utils = require("utils")
local nmap = utils.nmap
local vmap = utils.vmap

-- use space as leader key
vim.g.mapleader = " "

-- center window on search result
nmap({ "n", "nzzzv" })
nmap({ "N", "Nzzzv" })

--  close tab
nmap({ "<c-w>w", ":bd<CR>" })

-- rename current file
nmap({ "<Leader>rn", ":Move <C-R>=expand('%')<CR>" })

-- sort selected lines
vmap({ "gs", ":sort<CR>" })

-- remove highlighting on escape
nmap({ "<esc>", ":nohlsearch<cr>", { silent = true } })
