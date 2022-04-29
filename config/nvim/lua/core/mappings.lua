local utils = require 'utils'
local nmap = utils.nmap
local vmap = utils.vmap
local xmap = utils.vmap

local default_opts = { noremap = true, silent = true }

-- TODO: find out why this doesn't work with helper funcs or why I can't just
-- set the leader to space directly
-- alias for leader key (use space as leader)
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- set leader key to `\` so that I can alias it to <space>
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'
vim.cmd [[nmap <space> \]]
vim.cmd [[xmap <space> \]]

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

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- gD = go Declaration
  buf_nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  -- gD = go definition
  buf_nmap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  -- K = is just the vim help for thing under cursor
  buf_nmap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  -- gi = go implementation
  buf_nmap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  -- fs = function signature
  buf_nmap('<leader>fs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  -- wa = workspace add
  buf_nmap('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  -- wr = workspace remove
  buf_nmap('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  -- wl = workspace list
  buf_nmap('<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  -- D = <type> Definition
  buf_nmap('<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  -- rn = rename
  buf_nmap('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  -- ca = code action
  buf_nmap('<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  -- gr = get references
  buf_nmap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  -- fr = formatting
  buf_nmap('<leader>fr', '<cmd>lua vim.lsp.buf.formatting()<CR>')
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

M.telescope_mappings = function()
  -- " Find files using Telescope command-line sugar.
  nmap { '<C-p>', '<cmd>Telescope find_files<cr>', default_opts }
  nmap { '<leader>ff', '<cmd>Telescope find_files<cr>', default_opts }
  nmap { '<leader>lg', '<cmd>Telescope live_grep<cr>', default_opts }
  nmap { '<C-b>', '<cmd>Telescope buffers<cr>', default_opts }
  nmap { '<leader>bb', '<cmd>Telescope buffers<cr>', default_opts }

  nmap { '<leader>fh', '<cmd>Telescope help_tags<cr>', default_opts }

  --  Extensions
  nmap { '<leader>fb', '<cmd>Telescope file_browser<cr>', default_opts }
  nmap { '<leader>fp', '<cmd>Telescope packer<cr>', default_opts }
  nmap { '<leader>cc', '<cmd>Telescope conventional_commits<cr>', default_opts }

  -- check out pull requests from vim!
  nmap { '<leader>gp', '<cmd>Telescope gh pull_request<cr>', default_opts }
  nmap { '<leader>gi', '<cmd>Telescope gh issues<cr>', default_opts }
  nmap { '<leader>gs', '<cmd>Telescope gh gist<cr>', default_opts }
  nmap { '<leader>gr', '<cmd>Telescope gh run<cr>', default_opts }
end

M.fugitive_mappings = function()
  nmap { '<leader>gw', ':Gwrite<CR>', default_opts }
  nmap { '<leader>gb', ':Git blame<CR>', default_opts }
end

M.winresizer_mappings = function()
  nmap { '<C-w>r', '<cmd>WinResizerStartResize<CR>' }
end

M.ripgrep_mappings = function()
  --  Grep project for selection with Rg
  xmap { '<leader>gr', 'y :Rg "<CR>' }
  --  Grep project for word under the cursor with Rg
  nmap { '<Leader>gr :Rg', '<C-r><C-w><CR>' }

  --  Grep selection with Rg (excluding tests and migrations)
  xmap { '<leader>gt', "y :Rg \" -g '!*/**/test/*' -g '!*/**/migrations/*'<CR>" }
  nmap { '<Leader>gt', ":Rg <C-r><C-w> -g '!*/**/test/*' -g '!*/**/migrations/*'<CR>" }

  --  Put cursor after :Rg command (a little faster than typing :Rg)
  nmap { '<leader>rg ', ':Rg ' }
end

M.easy_align_mappings = function()
  nmap { '<leader>ea', ':EasyAlign ' }
end

M.vim_test_mappings = function()
  nmap { '<leader>T', ':TestNearest<CR>' }
  nmap { '<leader>t', ':TestFile<CR>' }
  nmap { '<leader>a', ':TestSuite<CR>' }
  nmap { '<leader>l', ':TestLast<CR>' }
end

M.undotree_mappings = function()
  nmap { '<leader>ut', '<cmd>UndotreeToggle<CR>' }
end

return M
