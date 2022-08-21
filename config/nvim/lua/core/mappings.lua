local utils = require 'core.utils'

--[[
╭────────────────────────────────────────────────────────────────────────────╮
│  Str  │  Help page   │  Affected modes                           │  VimL   │
│────────────────────────────────────────────────────────────────────────────│
│  ''   │  mapmode-nvo │  Normal, Visual, Select, Operator-pending │  :map   │
│  'n'  │  mapmode-n   │  Normal                                   │  :nmap  │
│  'v'  │  mapmode-v   │  Visual and Select                        │  :vmap  │
│  's'  │  mapmode-s   │  Select                                   │  :smap  │
│  'x'  │  mapmode-x   │  Visual                                   │  :xmap  │
│  'o'  │  mapmode-o   │  Operator-pending                         │  :omap  │
│  '!'  │  mapmode-ic  │  Insert and Command-line                  │  :map!  │
│  'i'  │  mapmode-i   │  Insert                                   │  :imap  │
│  'l'  │  mapmode-l   │  Insert, Command-line, Lang-Arg           │  :lmap  │
│  'c'  │  mapmode-c   │  Command-line                             │  :cmap  │
│  't'  │  mapmode-t   │  Terminal                                 │  :tmap  │
╰────────────────────────────────────────────────────────────────────────────╯
--]]

local map = function(tbl)
  vim.keymap.set(tbl[1], tbl[2], tbl[3], tbl[4])
end

local imap = function(tbl)
  vim.keymap.set('i', tbl[1], tbl[2], tbl[3])
end

local nmap = function(tbl)
  vim.keymap.set('n', tbl[1], tbl[2], tbl[3])
end

local vmap = function(tbl)
  vim.keymap.set('v', tbl[1], tbl[2], tbl[3])
end

local tmap = function(tbl)
  vim.keymap.set('t', tbl[1], tbl[2], tbl[3])
end

local cmap = function(tbl)
  vim.keymap.set('c', tbl[1], tbl[2], tbl[3])
end

local silent = { silent = true }
local default_opts = { noremap = true, silent = true }

-- TODO: find out why this doesn't work with helper funcs or why I can't just
-- set the leader to space directly
-- alias for leader key (use space as leader)
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', silent)
-- set leader key to `\` so that I can alias it to <space>
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'
vim.cmd [[nmap <space> \]]
vim.cmd [[vmap <space> \]]

-- center window on search result
nmap { 'n', 'nzzzv' }
nmap { 'N', 'Nzzzv' }

--  close tab
nmap { '<c-w>w', ':bd<CR>' }

-- rename current file
nmap { '<Leader>mv', ":Move <C-R>=expand('%')<CR>", default_opts }

-- sort selected lines
vmap { 'gs', ':sort<CR>' }

-- remove highlighting on escape
nmap { '<esc>', ':nohlsearch<cr>', silent }

-- ml = map lua: converts vim mapping to lua (roughly..)
nmap { '<leader>ml', "<cmd>s/\\v(.)(nore){-}map (.{-}) (.*)/\\1map { '\\3', '\\4' }/<cr>" }

-- reload (current) lua file (does not reload module though...)
nmap {
  '<leader>rl',
  utils.reload_current_luafile,
  default_opts,
}

-- replace word under cursor, globally, with confirmation
nmap { '<Leader>k', [[:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>]] }
vmap { '<Leader>k', 'y :%s/<C-r>"//gc<Left><Left><Left>' }

-- insert frozen string literal comment at the top of the file (ruby)
nmap { '<leader>fsl', 'ggO# frozen_string_literal: true<esc>jO<esc>' }

-- qq to record, Q to replay
nmap { 'Q', '@q' }

-- Tab/shift-tab to indent/outdent in visual mode.
vmap { '<Tab>', '>gv' }
vmap { '<S-Tab>', '<gv' }

-- Keep selection when indenting/outdenting.
vmap { '>', '>gv' }
vmap { '<', '<gv' }

-- Search for selected text
vmap { '*', '"xy/<C-R>x<CR>' }

--  Navigate neovim + neovim terminal emulator with alt+direction
tmap { '<C-h>', '<C-><C-n><C-w>h' }
tmap { '<C-j>', '<C-><C-n><C-w>j' }
tmap { '<C-k>', '<C-><C-n><C-w>k' }
tmap { '<C-l>', '<C-><C-n><C-w>l' }

-- easily escape terminal
tmap { '<leader><esc>', '<C-><C-n><esc><cr>' }
tmap { '<C-o>', '<C-><C-n><esc><cr>' }

-- command typo mapping
cmap { 'WQ', 'wq', default_opts }
cmap { 'Wq', 'wq', default_opts }
cmap { 'QA', 'qa', default_opts }
cmap { 'qA', 'qa', default_opts }
cmap { 'Q!', 'q!', default_opts }

-- zoom a vim pane, <C-w> = to re-balance
nmap { '<leader>-', ':wincmd _<cr>:wincmd \\|<cr>' }
nmap { '<leader>=', ':wincmd =<cr>' }

-- close all other windows with <leader>o
nmap { '<leader>wo', '<c-w>o' }

-- Index ctags from any project, including those outside Rails
nmap { '<Leader>ct', ':!ctags -R .<CR>' }

-- Switch between the last two files
nmap { '<tab><tab>', '<c-^>' }

-- copy to end of line
nmap { 'Y', 'y$' }

-- copy to system clipboard
nmap { 'gy', '"+y' }
vmap { 'gy', '"+y' }

-- copy to to system clipboard (till end of line)
nmap { 'gY', '"+y$' }

-- copy entire file
nmap { '<C-g>y', 'ggyG' }

-- copy entire file to system clipboard
nmap { '<C-g>Y', 'gg"+yG' }

-- disable arrow keys in normal mode
nmap { '<Up>', ':call animate#window_delta_height(10)<CR>' }
nmap { '<Down>', ':call animate#window_delta_height(-10)<CR>' }
nmap { '<Left>', ':call animate#window_delta_width(10)<CR>' }
nmap { '<Right>', ':call animate#window_delta_width(-10)<CR>' }

-- last typed word to lower case
imap { '<C-w>u', '<esc>guawA' }

-- last typed word to UPPER CASE
imap { '<C-w>U', '<esc>gUawA' }

-- entire line to lower case
imap { '<C-g>u', '<esc>guuA' }

-- entire line to UPPER CASE
imap { '<C-g>U', '<esc>gUUA' }

-- last word to title case
imap { '<C-w>t', '<esc>bvgU<esc>A' }

-- current line to title case
imap { '<C-g>t', [[<esc>:s/\v<(.)(\w*)/\u\1\L\2/g<cr>A]] }

-- Open files relative to current path:
nmap { '<leader>ed', ':edit <C-R>=expand("%:p:h") . "/" <CR>' }
nmap { '<leader>sp', ':split <C-R>=expand("%:p:h") . "/" <CR>' }
nmap { '<leader>vs', ':vsplit <C-R>=expand("%:p:h") . "/" <CR>' }

-- move lines up and down in visual mode
vmap { '<c-k>', ":move '<-2<CR>gv=gv" }
vmap { '<c-j>', ":move '>+1<CR>gv=gv" }

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
  -- ca = code action
  buf_nmap('<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  -- gr = get references
  buf_nmap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  -- fr = formatting
  buf_nmap('<leader>fr', '<cmd>lua vim.lsp.buf.formatting()<CR>')
end

M.lsp_diagnostic_mappings = function()
  nmap { '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', default_opts }
  nmap { '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', default_opts }
  nmap { ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', default_opts }
  nmap { '<leader>qd', '<cmd>lua vim.diagnostic.setloclist()<CR>', default_opts }
end

M.lsp_saga_mappings = function()
  -- Lsp finder find the symbol definition implmement reference
  nmap { 'gh', '<cmd>Lspsaga lsp_finder<CR>', silent }

  -- Code action
  nmap { '<leader>ca', '<cmd>Lspsaga code_action<CR>', silent }
  vmap { '<leader>ca', '<cmd><C-U>Lspsaga range_code_action<CR>', silent }

  -- Rename
  nmap { '<leader>rn', '<cmd>Lspsaga rename<CR>', silent }

  -- Definition preview
  nmap { 'gd', '<cmd>Lspsaga preview_definition<CR>', silent }

  -- Show line diagnostics
  nmap { '<leader>cd', '<cmd>Lspsaga show_line_diagnostics<CR>', silent }

  -- Show cursor diagnostic
  nmap { '<leader>cd', '<cmd>Lspsaga show_cursor_diagnostics<CR>', silent }

  -- Diagnsotic jump
  nmap { '[e', '<cmd>Lspsaga diagnostic_jump_prev<CR>', silent }
  nmap { ']e', '<cmd>Lspsaga diagnostic_jump_next<CR>', silent }

  -- Only jump to error
  nmap {
    '[E',
    function()
      require('lspsaga.diagnostic').goto_prev { severity = vim.diagnostic.severity.ERROR }
    end,
    silent,
  }

  nmap {
    ']E',
    function()
      require('lspsaga.diagnostic').goto_next { severity = vim.diagnostic.severity.ERROR }
    end,
    silent,
  }

  -- Outline
  nmap { '<leader>ol', '<cmd>LSoutlineToggle<CR>', silent }

  -- Hover Doc
  nmap { 'K', '<cmd>Lspsaga hover_doc<CR>', silent }

  -- Signature help
  nmap { '<leader>sh', '<Cmd>Lspsaga signature_help<CR>', silent }
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
  -- Find files using Telescope command-line sugar.
  nmap { '<C-p>', '<cmd>Telescope find_files<cr>', default_opts }
  nmap { '<leader>ff', '<cmd>Telescope find_files<cr>', default_opts }
  nmap { '<leader>lg', '<cmd>Telescope live_grep<cr>', default_opts }
  nmap { '<C-b>', '<cmd>Telescope buffers<cr>', default_opts }
  nmap { '<leader>bb', '<cmd>Telescope buffers<cr>', default_opts }

  nmap { '<leader>fh', '<cmd>Telescope help_tags<cr>', default_opts }

  -- Git
  -- bc = buffer commits (like gitv!)
  nmap { '<leader>bc', '<cmd>Telescope git_bcommits<cr>', default_opts }

  -- LSP
  -- ds = document symbols
  nmap { '<leader>ds', '<cmd>Telescope lsp_document_symbols<cr>', default_opts }

  --  Extensions
  nmap { '<leader>fb', '<cmd>Telescope file_browser<cr>', default_opts }
  nmap { '<leader>fp', '<cmd>Telescope packer<cr>', default_opts }
  nmap { '<leader>cc', '<cmd>Telescope conventional_commits<cr>', default_opts }

  -- GitHub
  -- check out pull requests from vim!
  nmap { '<leader>gp', '<cmd>Telescope gh pull_request<cr>', default_opts }
  nmap { '<leader>gi', '<cmd>Telescope gh issues<cr>', default_opts }
  nmap { '<leader>gs', '<cmd>Telescope gh gist<cr>', default_opts }
  nmap { '<leader>gw', '<cmd>Telescope gh run<cr>', default_opts }
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
  vmap { '<leader>gr', 'y :Rg "<CR>' }
  --  Grep project for word under the cursor with Rg
  nmap { '<Leader>gr', ':Rg <C-r><C-w><CR>' }

  --  alias for above
  --  Grep project for selection with Rg
  vmap { '<leader>rg', 'y :Rg "<CR>' }
  --  Grep project for word under the cursor with Rg
  nmap { '<Leader>rg', ':Rg <C-r><C-w><CR>' }

  --  Grep selection with Rg (excluding tests and migrations)
  vmap { '<leader>gt', "y :Rg \" -g '!*/**/test/*' -g '!*/**/migrations/*'<CR>" }
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

M.packer_mappings = function()
  nmap { '<leader>pl', '<cmd>PackerCompile<CR>' }
  nmap { '<leader>ps', '<cmd>PackerSync<CR>' }
  nmap { '<leader>pc', '<cmd>PackerClean<CR>' }
end

M.attempt_mappings = function(attempt)
  -- new attempt, selecting extension
  nmap { '<leader>sn', attempt.new_select, default_opts }
  -- run current attempt buffer
  nmap { '<leader>sr', attempt.run, default_opts }
  -- delete attempt from current buffer
  nmap { '<leader>sd', attempt.delete_buf, default_opts }
  -- rename attempt from current buffer
  nmap { '<leader>sc', attempt.rename_buf, default_opts }
  -- open one of the existing scratch buffers
  nmap { '<leader>sl', attempt.open_select, default_opts }
end

M.gitsigns_mappings = function(gitsigns, bufnr)
  local opts = { expr = true, buffer = bufnr }

  local next_hunk = function()
    if vim.wo.diff then
      return ']c'
    end
    vim.schedule(function()
      gitsigns.next_hunk()
    end)
    return '<Ignore>'
  end

  local prev_hunk = function()
    if vim.wo.diff then
      return '[c'
    end
    vim.schedule(function()
      gitsigns.prev_hunk()
    end)
    return '<Ignore>'
  end

  -- Navigation
  nmap { ']c', next_hunk, opts }
  nmap { '[c', prev_hunk, opts }

  -- Hunk operations
  -- Undo Hunk
  nmap { '<leader>uh', ':Gitsigns reset_hunk<CR>' }
  -- Stage Hunk
  nmap { '<leader>sh', ':Gitsigns stage_hunk<CR>' }
  -- Undo Stage Hunk
  nmap { '<leader>Sh', ':Gitsigns undo_stage_hunk<CR>' }

  -- Buffer operations
  -- Undo Buffer
  nmap { '<leader>ub', ':Gitsigns reset_hunk<CR>' }
  -- Stage Buffer
  nmap { '<leader>sb', ':Gitsigns stage_buffer<CR>' }
  -- Undo Stage Buffer
  nmap { '<leader>Sb', ':Gitsigns undo_stage_buffer<CR>' }

  -- Text object for git hunks (e.g. vih will select the hunk)
  map { { 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>' }
end

return M
