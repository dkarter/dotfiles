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

---@diagnostic disable-next-line: unused-local, unused-function
local cmap = function(tbl)
  vim.keymap.set('c', tbl[1], tbl[2], tbl[3])
end

--- returns a function that calls the specified telescope builtin
local telescope = function(fun, opts)
  if opts == nil then
    opts = {}
  end

  return function()
    require('telescope.builtin')[fun](opts)
  end
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

-- stylua: ignore
M.lsp_mappings = function()
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  nmap { 'gD', vim.lsp.buf.declaration, { buffer = true, desc = '[G]o to [D]ecleration' } }
  nmap { 'gd', telescope('lsp_definitions', { reuse_win = true }), { buffer = true, desc = '[G]o to [d]efinition' }, }
  nmap { 'gi', vim.lsp.buf.implementation, { buffer = true, desc = '[G]o to [I]mplementation' } }
  nmap { '<leader>D', vim.lsp.buf.type_definition, { buffer = true, desc = 'Type [D]ef' } }
  map { { 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = true, desc = '[C]ode [A]ction' } }
  nmap { 'gr', telescope('lsp_references'), { buffer = true, desc = '[G]o to [R]eferences' } }
  nmap { 'K', vim.lsp.buf.hover, { buffer = true, desc = 'LSP Hover Doc' } }
  nmap { '<leader>rn', vim.lsp.buf.rename, { buffer = true, desc = '[R]e[n]ame Symbol Under Cursor' } }
end

M.lsp_diagnostic_mappings = function()
  local function diagnostic_goto(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
      go { severity = severity }
    end
  end

  nmap { '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = '[D]iagnostic [O]pen [F]loat' } }
  nmap { ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' } }
  nmap { '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' } }
  nmap { ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' } }
  nmap { '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' } }
  nmap { ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' } }
  nmap { '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' } }

  nmap { '<leader>qd', '<cmd>lua vim.diagnostic.setloclist()<CR>', { desc = 'Set loclist to LSP diagnostics' } }
end

M.elixir_mappings = function()
  nmap { '<space>fp', ':ElixirFromPipe<cr>', { desc = '[F]rom [P]ipe', buffer = true, noremap = true } }
  nmap { '<space>tp', ':ElixirToPipe<cr>', { desc = '[T]o [P]ipe', buffer = true, noremap = true } }
  vmap { '<space>em', ':ElixirExpandMacro<cr>', { desc = '[E]xpand [M]acro', buffer = true, noremap = true } }
end

M.zen_mode_mappings = {
  { '<leader>zm', '<cmd>ZenMode<cr>', desc = 'Zen Mode (Toggle)' },
}

M.trouble_mappings = {
  { '<leader>xw', '<cmd>Trouble workspace_diagnostics<cr>', desc = 'Workspace Diagnostics' },
  { '<leader>xd', '<cmd>Trouble document_diagnostics<cr>', desc = 'Document Diagnostics' },
  { '<leader>xl', '<cmd>Trouble loclist<cr>', desc = 'Open Loclist' },
  { '<leader>xq', '<cmd>Trouble quickfix<cr>', desc = 'Open Quickfix' },
  -- smart `[q` and `]q` mappings that work for both qf list and trouble
  {
    '[q',
    function()
      if require('trouble').is_open() then
        require('trouble').previous { skip_groups = true, jump = true }
      else
        local ok, err = pcall(vim.cmd.cprev)
        if not ok then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end
    end,
    desc = 'Previous trouble/quickfix item',
  },
  {
    ']q',
    function()
      if require('trouble').is_open() then
        require('trouble').next { skip_groups = true, jump = true }
      else
        local ok, err = pcall(vim.cmd.cnext)
        if not ok then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end
    end,
    desc = 'Next trouble/quickfix item',
  },
  { 'gR', '<cmd>Trouble lsp_references<cr>', desc = '[G]o to [R]eferences (Trouble)' },
}

-- stylua: ignore
M.todo_comments_mappings = {
  { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
  { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
  { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
  { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
  { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
  { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
}

-- stylua: ignore
M.flash_mappings ={
  { "<leader><leader>", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  { "<leader><cr>", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
}

M.nvim_tree_mappings = {
  { '<leader>nt', '<cmd>NvimTreeToggle<CR>', { desc = '[N]vimTree [T]oggle' } },
}

M.neogen_mappings = {
  { '<leader>nf', ":lua require('neogen').generate()<CR>", { desc = '[N]eogen [F]unction' } },
}

M.telescope_mappings = {
  -- muscle memory
  { '<C-p>', telescope 'find_files', default_opts },
  { '<C-b>', telescope 'buffers', default_opts },

  -- Compatible with hydra setup
  { '<leader>f/', telescope 'current_buffer_fuzzy_find', desc = 'Buffer fuzzy find' },
  { '<leader>f:', telescope 'commands', desc = 'Command search' },
  { '<leader>f;', telescope 'command_history', desc = 'Command History' },
  { '<leader>f?', telescope 'search_history', desc = 'Search History' },
  { '<leader>ff', telescope 'find_files', desc = '[F]ind [F]iles' },
  { '<leader>fg', telescope 'live_grep', desc = '[F]ind w/ [G]rep' },
  { '<leader>fh', telescope 'help_tags', desc = '[F]ind [H]elp' },
  { '<leader>fk', telescope 'keymaps', desc = '[F]ind [K]eymaps' },
  { '<leader>fo', telescope 'oldfiles', desc = '[F]ind [o]ld files' },
  { '<leader>fO', telescope 'vim_options', desc = '[F]ind [O]ptions' },
  { '<leader>fr', telescope 'resume', desc = '[F]ind [R]esume' },
  { '<leader>fd', require('plugins.telescope').find_dotfiles, desc = '[F]ind [D]otfiles' },
  { '<leader>fs', telescope 'git_status', desc = '[F]ind (Git) [S]tatus' },
  { '<leader>fw', telescope 'grep_string', desc = '[F]ind [W]ord' },

  --  Extensions
  { '<leader>fb', '<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>', desc = '[F]ile [B]rowser' },

  { '<leader>lg', telescope 'live_grep', desc = '[L]ive [G]rep' },
  { '<leader>bb', telescope 'buffers', desc = 'Find Buffers' },

  -- better spell suggestions
  { 'z=', telescope 'spell_suggest', desc = 'Spelling Suggestions' },

  -- Git
  -- bc = buffer commits (like gitv!)
  { '<leader>bc', telescope 'git_bcommits', desc = '[B]uffer [C]ommits' },

  -- LSP
  -- ds = document symbols
  { '<leader>ds', telescope 'lsp_document_symbols', desc = '[D]ocument [S]ymbols' },

  { '<leader>cc', '<cmd>Telescope conventional_commits<cr>', desc = '[C]onventional [C]ommits' },

  -- search unicode symbols 
  { '<leader>fu', '<cmd>Telescope symbols<cr>', desc = '[F]ind [U]nicode' },
  { '<C-q>', '<cmd>Telescope symbols<cr>', mode = 'i', desc = '[F]ind [U]nicode' },
}

M.blame_nvim_mappings = {
  -- Git Blame
  { '<leader>gb', ':BlameToggle<CR>', desc = '[G]it [B]lame' },
}

M.gen_nvim_mappings = {
  { '<leader>ai', ':Gen<CR>', mode = { 'n', 'v' }, desc = 'AI tools using Ollama' },
  { '<leader>aa', ':Gen Ask<CR>', mode = { 'n', 'v' }, desc = '[A]I [A]sk' },
  {
    '<leader>am',
    function()
      require('gen').select_model()
    end,
    mode = { 'n', 'v' },
    desc = 'Select [A]I [m]odel',
  },
}

M.fugitive_mappings = function()
  -- Git Stage file
  nmap { '<leader>gS', ':Gwrite<CR>', { desc = '[G]it [S]tage' } }

  --  Revert file
  nmap { '<Leader>gR', ':Gread<CR>', { desc = '[G]it [R]ead (reverts file)' } }
end

M.rhubarb_mappings = {
  -- open github page for file
  { '<leader>gO', ':GBrowse<CR>', desc = '[G]ithub [O]pen File' },

  -- open github page for line under cursor
  { '<leader>go', ':.GBrowse<CR>', desc = '[G]ithub [o]pen Line' },

  -- open github page for selection
  { '<leader>go', ':GBrowse<CR>', mode = 'v', desc = '[G]ithub [o]pen Line' },

  -- copy github link for file
  {
    '<leader>gY',
    ':GBrowse! | lua vim.notify("Copied file URL to clipboard")<CR>',
    desc = '[G]ithub [Y]ank file URL',
  },

  -- copy github link for line under cursor
  {
    '<leader>gy',
    ':.GBrowse! | lua vim.notify("Copied line URL to clipboard")<CR>',
    desc = '[G]ithub [y]ank line URL',
  },

  -- copy github link for selection
  {
    '<leader>gy',
    ':GBrowse! | lua vim.notify("Copied selection URL to clipboard")<CR>',
    mode = 'v',
    desc = '[G]ithub [Y]ank selection link',
  },
}

M.diffview_mappings = {
  { '<leader>gv', '<cmd>DiffviewFileHistory %<CR>', desc = '[G]it [V]iew (:gitv! alt)' },
  { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = '[G]it [D]iff' },
}

M.ripgrep_mappings = {
  --  alias for above
  --  Grep project for selection with Rg
  { '<leader>rg', 'y :Rg "<CR>', mode = 'v', desc = '[R]ip[G]rep selection' },
  --  Grep project for word under the cursor with Rg
  { '<Leader>rg', ':Rg <C-r><C-w><CR>', desc = '[R]ip[G]rep word under cursor' },
}

M.easy_align_mappings = {
  { '<leader>ea', ':EasyAlign ', desc = '[E]asy [A]lign' },
  { '<leader>ea', ':EasyAlign ', mode = 'v', desc = '[E]asy [A]lign' },
}

---@type LazyKeys[]
M.vim_test_mappings = {
  { '<leader>tn', ':TestNearest<CR>', silent = true, desc = '[T]est [N]earest' },
  { '<leader>tf', ':TestFile<CR>', silent = true, desc = '[T]est [F]ile' },
  { '<leader>ts', ':TestSuite<CR>', silent = true, desc = '[T]est [S]uite' },
  { '<leader>tl', ':TestLast<CR>', silent = true, desc = '[T]est [L]ast' },
}

M.undotree_mappings = {
  { '<leader>ut', '<cmd>UndotreeToggle<CR>', desc = '[U]ndo [T]ree' },
}

M.attempt_mappings = {
  -- new attempt, selecting extension
  { '<leader>sn', '<cmd>lua require("attempt").new_select()<CR>', desc = '[S]cratch [N]ew' },
  -- run current attempt buffer
  { '<leader>sr', '<cmd>lua require("attempt").run()<CR>', desc = '[S]cratch [R]un' },
  -- delete attempt from current buffer
  { '<leader>sd', '<cmd>lua require("attempt").delete_buf()<CR>', desc = '[S]cratch [D]elete (current buffer)' },
  -- rename attempt from current buffer
  { '<leader>sc', '<cmd>lua require("attempt").rename_buf()<CR>', desc = '[S]cratch Rename (current buffer)' },
  -- open one of the existing scratch buffers
  { '<leader>sl', '<cmd>Telescope attempt<CR>', desc = '[S]cratch [L]oad' },
}

local bufremove_others = function(force)
  return function()
    local bufremove = require('mini.bufremove').delete
    local curr_buf = vim.api.nvim_get_current_buf()
    local buf_list = vim.api.nvim_list_bufs()
    local deleted_count = 0

    for _, bufnr in pairs(buf_list) do
      if bufnr ~= curr_buf then
        bufremove(bufnr, force)
        deleted_count = deleted_count + 1
      end
    end
    vim.notify('Removed ' .. deleted_count .. ' buffers')
  end
end

local bufremove_curr = function(force)
  return function()
    require('mini.bufremove').delete(0, force)
  end
end

M.bufremove_mappings = {
  { '<leader>bd', bufremove_curr(false), desc = 'Delete Buffer' },
  { '<leader>bD', bufremove_curr(true), desc = 'Delete Buffer (Force)' },
  { '<leader>bo', bufremove_others(false), desc = 'Delete Other Buffers' },
  { '<leader>bO', bufremove_others(true), desc = 'Delete Other Buffers (Force)' },
}

M.gitsigns_mappings = function(bufnr)
  local gitsigns = require 'gitsigns'
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

M.notify_mappings = function()
  local notify = require 'notify'
  nmap { '<leader>nd', notify.dismiss, { desc = '[N]otification [D]ismiss' } }
end

return M
