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
nmap { '<Leader>RN', ":Move <C-R>=expand('%')<CR>" }

-- sort selected lines
vmap { 'gs', ':sort<CR>' }

-- remove highlighting on escape
nmap { '<esc>', ':nohlsearch<cr>', { silent = true } }

local M = {}

M.lsp_mappings = function(bufnr)
  local opts = { noremap = true, silent = true }

  local buf_nmap = function(mapping, cmd)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', mapping, cmd, opts)
  end

  -- TODO: expose this as a function from mappings module e.g. require('core.mappings').lsp_mappings()
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  buf_nmap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  buf_nmap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  buf_nmap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  buf_nmap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  buf_nmap('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  buf_nmap('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  buf_nmap('<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  buf_nmap('<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  buf_nmap('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  buf_nmap('<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  buf_nmap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  buf_nmap('<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
end

M.lsp_diagnostic_mappings = function()
  local opts = { noremap = true, silent = true }
  nmap { '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts }
  nmap { '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts }
  nmap { ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts }
  nmap { '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts }
end

return M
