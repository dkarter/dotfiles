local utils = require 'utils'
local nmap = utils.nmap
local vmap = utils.vmap

local default_opts = { noremap = true, silent = true }

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
  local buf_nmap = function(mapping, cmd)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', mapping, cmd, default_opts)
  end

  -- TODO: expose this as a function from mappings module e.g. require('core.mappings').lsp_mappings()
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  buf_nmap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  buf_nmap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  buf_nmap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  -- fs = function signature
  buf_nmap('<leader>fs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
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
  nmap { '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', default_opts }
  nmap { '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', default_opts }
  nmap { ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', default_opts }
  nmap { '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', default_opts }
end

M.trouble_mappings = function()
  nmap { '<leader>xx', '<cmd>Trouble<cr>', default_opts }
  nmap { '<leader>xw', '<cmd>Trouble workspace_diagnostics<cr>', default_opts }
  nmap { '<leader>xd', '<cmd>Trouble document_diagnostics<cr>', default_opts }
  nmap { '<leader>xl', '<cmd>Trouble loclist<cr>', default_opts }
  nmap { '<leader>xq', '<cmd>Trouble quickfix<cr>', default_opts }
  nmap { 'gR', '<cmd>Trouble lsp_references<cr>', default_opts }
end

M.nvim_tree_mappings = function()
  nmap { '<leader>nt', ':NvimTreeToggle<CR>', default_opts }
end

return M
