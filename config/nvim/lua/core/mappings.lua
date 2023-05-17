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

---@diagnostic disable-next-line: unused-local, unused-function
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

-- center window on search result
nmap { 'n', 'nzzzv' }
nmap { 'N', 'Nzzzv' }

-- rename current file
nmap { '<Leader>mv', ":Move <C-R>=expand('%')<CR>", { desc = 'Move current file' } }

-- copy current file
nmap { '<Leader>sa', ":saveas <C-R>=expand('%')<CR><Left><Left><Left>", { desc = '[S]ave [A]s current file' } }

-- sort selected lines
vmap { 'gs', ':sort<CR>' }

-- remove highlighting on escape
nmap { '<esc>', ':nohlsearch<cr>', silent }

-- reload (current) lua file (does not reload module though...)
nmap {
  '<leader>rl',
  utils.reload_current_luafile,
  { desc = 'Reload Current Lua File' },
}

-- replace word under cursor, globally, with confirmation
nmap { '<Leader>k', [[:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>]] }
vmap { '<Leader>k', 'y :%s/<C-r>"//gc<Left><Left><Left>' }

-- insert frozen string literal comment at the top of the file (ruby)
nmap { '<leader>fsl', 'ggO# frozen_string_literal: true<esc>jO<esc>' }

-- qq to record (built-in), Q to replay
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
nmap { '<leader>-', ':wincmd _<cr>:wincmd \\|<cr>', { desc = 'Zoom window' } }
nmap { '<leader>=', ':wincmd =<cr>', { desc = 'Rebalance window sizes' } }

-- close all other windows with <leader>o
nmap { '<leader>wo', '<c-w>o', { desc = 'Close other windows' } }

-- Switch between the last two files
nmap { '<tab><tab>', '<c-^>', { desc = 'Switch between alternate buffers' } }

-- copy to end of line
nmap { 'Y', 'y$', { desc = 'Yank to EOL' } }

-- copy to system clipboard
nmap { 'gy', '"+y', { desc = 'Yank to clipboard' } }
vmap { 'gy', '"+y', { desc = 'Yank to clipboard' } }

-- copy to to system clipboard (till end of line)
nmap { 'gY', '"+y$', { desc = 'Yank to clipboard EOL' } }

-- copy entire file
nmap { '<C-g>y', 'ggyG', { desc = 'Copy Entire File' } }

-- copy entire file to system clipboard
nmap { '<C-g>Y', 'gg"+yG', { desc = 'Copy Entire File To System Clipboard' } }

-- Open files relative to current path:
nmap { '<leader>ed', ':edit <C-R>=expand("%:p:h") . "/" <CR>', { desc = '[ED]it file' } }
nmap { '<leader>sp', ':split <C-R>=expand("%:p:h") . "/" <CR>', { desc = '[SP]lit file' } }
nmap { '<leader>vs', ':vsplit <C-R>=expand("%:p:h") . "/" <CR>', { desc = '[V]ertical [S]plit file' } }

-- move lines up and down in visual mode
vmap { '<c-k>', ":move '<-2<CR>gv=gv", { desc = 'Move selection up' } }
vmap { '<c-j>', ":move '>+1<CR>gv=gv", { desc = 'Move selection down' } }

-- source current file (useful when iterating on config)
nmap {
  '<leader>so',
  ':source %<CR>:lua vim.notify("File sourced!")<CR>',
  { desc = '[SO]urce file' },
}

-- Lazy.nvim (plugin manager)
nmap { '<leader>ps', '<cmd>Lazy sync<CR>', { desc = '[P]lugin [S]ync' } }
nmap { '<leader>pc', '<cmd>Lazy clean<CR>', { desc = '[P]lugin [C]lean' } }

local M = {}

M.lsp_mappings = function(bufnr)
  local buf_nmap = function(mapping, cmd, opts)
    local merged_opts = vim.tbl_extend('force', default_opts, opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', mapping, cmd, merged_opts)
  end

  local buf_vmap = function(mapping, cmd, opts)
    local merged_opts = vim.tbl_extend('force', default_opts, opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'v', mapping, cmd, merged_opts)
  end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- gD = go Declaration
  buf_nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { desc = '[G]o to [D]ecleration' })
  -- gD = go definition
  buf_nmap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { desc = '[G]o to [d]efinition' })
  -- gi = go implementation
  buf_nmap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { desc = '[G]o to [I]mplementation' })
  -- fs = function signature
  buf_nmap('<leader>fs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = '[F]unction [S]ignature' })
  -- wa = workspace add
  buf_nmap('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { desc = '[W]orkspace [A]dd' })
  -- wr = workspace remove
  buf_nmap('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { desc = '[W]orkspace [R]emove' })
  -- wl = workspace list
  buf_nmap(
    '<leader>wl',
    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
    { desc = '[W]orkspace [L]ist' }
  )
  -- D = <type> Definition
  buf_nmap('<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { desc = 'Type Def' })
  -- ca = code action
  buf_nmap('<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = '[C]ode [A]ction' })
  -- ca = code action
  buf_vmap('<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = '[C]ode [A]ction' })
  -- gr = get references
  buf_nmap('gr', '<cmd>lua vim.lsp.buf.references()<CR>', { desc = '[G]o to [R]eferences' })
end

M.lsp_diagnostic_mappings = function()
  -- TODO: These are a bit redundant with LSP Saga and Trouble.nvim - consider removing them
  nmap { '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = '[D]iagnostic [O]pen [F]loat' } }
  nmap { '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = 'Prev Diagnostic' } }
  nmap { ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc = 'Next Diagnostic' } }
  nmap { '<leader>qd', '<cmd>lua vim.diagnostic.setloclist()<CR>', { desc = 'Set loclist to LSP diagnostics' } }
end

M.lsp_saga_mappings = function()
  -- Lsp finder find the symbol definition implmement reference
  nmap { '<leader>lf', '<cmd>Lspsaga lsp_finder<CR>', { desc = '[L]sp [F]inder' } }

  -- Rename
  nmap { '<leader>rn', '<cmd>Lspsaga rename<CR>', { desc = 'Rename LSP Symbol' } }

  -- Definition preview
  nmap { 'gp', '<cmd>Lspsaga peek_definition<CR>', { desc = 'Peek definition' } }

  -- Diagnsotic jump
  nmap { '[e', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { desc = 'Previous Diagnostic Error' } }
  nmap { ']e', '<cmd>Lspsaga diagnostic_jump_next<CR>', { desc = 'Next Diagnostic Error' } }

  -- Hover Doc
  nmap { 'K', '<cmd>Lspsaga hover_doc<CR>', { desc = 'LSP Hover Doc' } }
end

M.trouble_mappings = function()
  nmap { '<leader>xw', '<cmd>Trouble workspace_diagnostics<cr>', { desc = 'Workspace Diagnostics' } }
  nmap { '<leader>xd', '<cmd>Trouble document_diagnostics<cr>', { desc = 'Document Diagnostics' } }
  nmap { '<leader>xl', '<cmd>Trouble loclist<cr>', { desc = 'Open Loclist' } }
  nmap { '<leader>xq', '<cmd>Trouble quickfix<cr>', { desc = 'Open Quickfix' } }
  nmap { 'gR', '<cmd>Trouble lsp_references<cr>', { desc = '[G]o to [R]eferences (Trouble)' } }
end

M.hop_mappings = function()
  nmap { '<leader>hp', '<cmd>HopPattern<cr>', { desc = '[H]op [P]attern' } }
  nmap { '<leader>hw', '<cmd>HopWord<cr>', { desc = '[H]op [W]ord' } }
end

M.nvim_tree_mappings = function()
  nmap { '<leader>nt', ':NvimTreeToggle<CR>', { desc = '[N]vimTree [T]oggle' } }
end

M.telescope_mappings = function()
  -- muscle memory
  nmap { '<C-p>', '<cmd>Telescope find_files<cr>', default_opts }
  nmap { '<C-b>', '<cmd>Telescope buffers<cr>', default_opts }

  -- Compatible with hydra setup
  nmap { '<leader>f/', '<cmd>Telescope current_buffer_fuzzy_find<cr>', { desc = 'Buffer fuzzy find' } }
  nmap { '<leader>f:', '<cmd>Telescope commands<cr>', { desc = 'Command search' } }
  nmap { '<leader>f;', '<cmd>Telescope command_history<cr>', { desc = 'Command History' } }
  nmap { '<leader>f?', '<cmd>Telescope search_history<cr>', { desc = 'Search History' } }
  nmap { '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = '[F]ind [F]iles' } }
  nmap { '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = '[F]ind w/ [G]rep' } }
  nmap { '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = '[F]ind [H]elp' } }
  nmap { '<leader>fk', '<cmd>Telescope keymaps<cr>', { desc = '[F]ind [K]eymaps' } }
  nmap { '<leader>fo', '<cmd>Telescope oldfiles<cr>', { desc = '[F]ind [o]ld files' } }
  nmap { '<leader>fO', '<cmd>Telescope vim_options<cr>', { desc = '[F]ind [O]ptions' } }
  nmap { '<leader>fr', '<cmd>Telescope resume<cr>', { desc = '[F]ind [R]esume' } }

  --  Extensions
  nmap { '<leader>fb', '<cmd>Telescope file_browser<cr>', { desc = '[F]ile [B]rowser' } }

  nmap { '<leader>lg', '<cmd>Telescope live_grep<cr>', { desc = '[L]ive [G]rep' } }
  nmap { '<leader>bb', '<cmd>Telescope buffers<cr>', { desc = 'Find Buffers' } }

  -- better spell suggestions
  nmap { 'z=', '<cmd>Telescope spell_suggest<cr>', { desc = 'Spelling Suggestions' } }

  -- Git
  -- bc = buffer commits (like gitv!)
  nmap { '<leader>bc', '<cmd>Telescope git_bcommits<cr>', { desc = '[B]uffer [C]ommits' } }

  -- LSP
  -- ds = document symbols
  nmap { '<leader>ds', '<cmd>Telescope lsp_document_symbols<cr>', { desc = '[D]ocument [S]ymbols' } }

  nmap { '<leader>cc', '<cmd>Telescope conventional_commits<cr>', { desc = '[C]onventional [C]ommits' } }

  -- GitHub
  nmap { '<leader>ga', '<cmd>Telescope gh run<cr>', { desc = '[G]ithub [A]ctions' } }
  nmap { '<leader>gg', '<cmd>Telescope gh gist<cr>', { desc = '[G]ithub [G]ist' } }
  nmap { '<leader>gi', '<cmd>Telescope gh issues<cr>', { desc = '[G]ithub [I]ssues' } }
  nmap { '<leader>gp', '<cmd>Telescope gh pull_request<cr>', { desc = '[G]ithub [P]ull Requsts' } }
end

M.fugitive_mappings = function()
  -- Git Stage file
  nmap { '<leader>gS', ':Gwrite<CR>', { desc = '[G]it [S]tage' } }

  -- Git Blame
  nmap { '<leader>gb', ':Git blame<CR>', { desc = '[G]it [B]lame' } }
  vmap { '<leader>gb', ':Git blame<CR>', { desc = '[G]it [B]lame' } }

  --  Revert file
  nmap { '<Leader>gR', ':Gread<CR>', { desc = '[G]it [R]ead (reverts file)' } }

  -- open github page for file
  nmap { '<leader>gO', ':GBrowse<CR>', { desc = '[G]ithub [O]pen File' } }

  -- open github page for line under cursor
  nmap { '<leader>go', ':.GBrowse<CR>', { desc = '[G]ithub [o]pen Line' } }

  -- open github page for selection
  vmap { '<leader>go', ':GBrowse<CR>', { desc = '[G]ithub [o]pen Line' } }

  -- copy github link for file
  nmap {
    '<leader>gY',
    ':GBrowse! | lua vim.notify("Copied file URL to clipboard")<CR>',
    { desc = '[G]ithub [Y]ank file URL' },
  }

  -- copy github link for line under cursor
  nmap {
    '<leader>gy',
    ':.GBrowse! | lua vim.notify("Copied line URL to clipboard")<CR>',
    { desc = '[G]ithub [y]ank line URL' },
  }

  -- copy github link for selection
  vmap {
    '<leader>gy',
    ':GBrowse! | lua vim.notify("Copied selection URL to clipboard")<CR>',
    { desc = '[G]ithub [Y]ank selection link' },
  }
end

M.winresizer_mappings = function()
  nmap { '<C-w>r', '<cmd>WinResizerStartResize<CR>' }
end

M.ripgrep_mappings = function()
  --  alias for above
  --  Grep project for selection with Rg
  vmap { '<leader>rg', 'y :Rg "<CR>', { desc = '[R]ip[G]rep selection' } }
  --  Grep project for word under the cursor with Rg
  nmap { '<Leader>rg', ':Rg <C-r><C-w><CR>', { desc = '[R]ip[G]rep word under cursor' } }

  --  Grep selection with Rg (excluding tests and migrations)
  vmap { '<leader>gt', "y :Rg \" -g '!*/**/test/*' -g '!*/**/migrations/*'<CR>" }
  nmap { '<Leader>gt', ":Rg <C-r><C-w> -g '!*/**/test/*' -g '!*/**/migrations/*'<CR>" }
end

M.easy_align_mappings = function()
  nmap { '<leader>ea', ':EasyAlign ', { desc = '[E]asy [A]lign' } }
end

M.vim_test_mappings = function()
  nmap { '<leader>tn', ':TestNearest<CR>', { desc = '[T]est [N]earest' } }
  nmap { '<leader>tf', ':TestFile<CR>', { desc = '[T]est [F]ile' } }
  nmap { '<leader>ts', ':TestSuite<CR>', { desc = '[T]est [S]uite' } }
  nmap { '<leader>tl', ':TestLast<CR>', { desc = '[T]est [L]ast' } }
end

M.undotree_mappings = function()
  nmap { '<leader>ut', '<cmd>UndotreeToggle<CR>', { desc = '[U]ndo [T]ree' } }
end

M.attempt_mappings = function(attempt)
  -- new attempt, selecting extension
  nmap { '<leader>sn', attempt.new_select, { desc = '[S]cratch [N]ew' } }
  -- run current attempt buffer
  nmap { '<leader>sr', attempt.run, { desc = '[S]cratch [R]un' } }
  -- delete attempt from current buffer
  nmap { '<leader>sd', attempt.delete_buf, { desc = '[S]cratch [D]elete (current buffer)' } }
  -- rename attempt from current buffer
  nmap { '<leader>sc', attempt.rename_buf, { desc = '[S]cratch Rename (current buffer)' } }
  -- open one of the existing scratch buffers
  nmap { '<leader>sl', attempt.open_select, { desc = '[S]cratch [L]oad' } }
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
  nmap { ']h', next_hunk, opts }
  nmap { '[h', prev_hunk, opts }

  -- Hunk operations
  -- Reset Hunk
  nmap { '<leader>gr', ':Gitsigns reset_hunk<CR>', { buffer = bufnr, desc = '[G]it [R]eset Hunk' } }
  vmap { '<leader>gr', ':Gitsigns reset_hunk<CR>', { buffer = bufnr, desc = '[G]it [R]eset Hunk' } }
  -- Stage Hunk
  nmap { '<leader>gs', ':Gitsigns stage_hunk<CR>', { buffer = bufnr, desc = '[G]it [S]age Hunk' } }
  vmap { '<leader>gs', ':Gitsigns stage_hunk<CR>', { buffer = bufnr, desc = '[G]it [S]age Hunk' } }
  -- Undo Stage Hunk
  nmap { '<leader>gu', ':Gitsigns undo_stage_hunk<CR>', { buffer = bufnr, desc = '[G]it [U]ndo Stage Hunk' } }
  vmap { '<leader>gu', ':Gitsigns undo_stage_hunk<CR>', { buffer = bufnr, desc = '[G]it [U]ndo Stage Hunk' } }

  -- Text object for git hunks (e.g. vih will select the hunk)
  map { { 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>' }
end

return M
