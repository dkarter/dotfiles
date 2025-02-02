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

local picker = function(fun, opts)
  if opts == nil then
    opts = {}
  end

  return function()
    Snacks.picker[fun](opts)
  end
end

local silent = { silent = true }

-- center window on search result
nmap { 'n', 'nzzzv' }
nmap { 'N', 'Nzzzv' }

-- rename current file
nmap { '<Leader>mv', ":Move <C-R>=expand('%')<CR>", { desc = 'Move current file' } }

-- copy current file
nmap { '<Leader>sa', ":saveas <C-R>=expand('%')<CR><Left><Left><Left>", { desc = '[S]ave [A]s current file' } }

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
  nmap { 'gi', vim.lsp.buf.implementation, { buffer = true, desc = '[G]o to [I]mplementation' } }
  nmap { '<leader>D', vim.lsp.buf.type_definition, { buffer = true, desc = 'Type [D]ef' } }
  map { { 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = true, desc = '[C]ode [A]ction' } }
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

-- stylua: ignore
---@type LazyKeysSpec[]
M.splitjoin_mappings = {
  {'gJ', function() require('treesj').join() end, desc = 'Join Code Block' },
  {'gS', function() require('treesj').split() end, desc = 'Split Code Block' },
}

---@type LazyKeysSpec[]
M.sort_mappings = {
  { 'go', ':Sort<CR>', mode = 'v', desc = '(go) Order (sort lines/line params)' },
  { "goi'", "vi':Sort<CR>", mode = 'n', desc = "(go) [O]rder [i]n [']" },
  { 'goi"', 'vi":Sort<CR>', mode = 'n', desc = '(go) [O]rder [i]n ["]' },
  { 'goi(', 'vi(:Sort<CR>', mode = 'n', desc = '(go) [O]rder [i]n (' },
  { 'goi[', 'vi[:Sort<CR>', mode = 'n', desc = '(go) [O]rder [i]n [' },
  { 'goip', 'vip:Sort<CR>', mode = 'n', desc = '(go) [O]rder [i]n [p]aragraph' },
  { 'goi{', 'vi{:Sort<CR>', mode = 'n', desc = '(go) [O]rder [i]n {' },
}

---@type LazyKeysSpec[]
M.trouble_mappings = {
  { '<leader>xw', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Workspace Diagnostics' },
  { '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Document Diagnostics' },
  { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = 'Open Loclist' },
  { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Open Quickfix' },
  {
    '<leader>ss',
    '<cmd>Trouble symbols toggle focus=true<cr>',
    desc = 'Symbols (Trouble)',
  },
  {
    '<leader>sl',
    '<cmd>Trouble lsp toggle focus=true win.position=right<cr>',
    desc = 'LSP Definitions / references / ... (Trouble)',
  },
  -- smart `[q` and `]q` mappings that work for both qf list and trouble
  {
    '[q',
    function()
      if require('trouble').is_open() then
        ---@diagnostic disable-next-line: missing-parameter
        require('trouble').prev { skip_groups = true, jump = true }
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
        ---@diagnostic disable-next-line: missing-parameter
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
---@type LazyKeysSpec[]
M.nvim_dap_mappings = {
  { '<leader>dd', function() require('dap').continue() end, desc = '[D]ebug: Start/Continue' },
  { '<leader>dc', function() require('dap').continue() end, desc = '[D]ebug: Continue' },
  { '<leader>di', function() require('dap').step_into() end , desc = '[D]ebug: Step [I]nto' },
  { '<leader>do', function() require('dap').step_over() end, desc = '[D]ebug: Step [o]ver' },
  { '<leader>dO', function() require('dap').step_out() end, desc = '[D]ebug: Step [O]ut' },
  { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = '[D]ebug: Toggle [B]reakpoint' },
  { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = '[D]ebug: Toggle (Conditional) [B]reakpoint' },
  { '<leader>?',  function() require('dapui').eval(nil, { enter = true }) end, desc = 'Debug: Show Value' },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
  { '<leader>dt', function() require('dapui').toggle() end, desc = '[D]ebug [T]oggle' },
}

-- stylua: ignore
---@type LazyKeysSpec[]
M.todo_comments_mappings = {
  { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
  { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
  { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
  { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
  { "<leader>st", picker('todo_comments'),                            desc = "Todo" },
  { "<leader>sT", picker('todo_comments', { keywords = { "TODO", "FIX", "FIXME" } }),    desc = "Todo/Fix/Fixme" },
}

-- stylua: ignore
---@type LazyKeysSpec[]
M.flash_mappings = {
  { "<leader><leader>", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
  { "<leader><cr>",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  { "f" },
  { "F"},
  {"t"},
  {"T"},
  {";"},
  {","}
}

---@type LazyKeysSpec[]
M.oil_nvim_mappings = {
  { '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' } },
  {
    '<leader>-',
    function()
      require('oil').toggle_float()
    end,
    { desc = 'Open parent directory (float)' },
  },
}

---@type LazyKeysSpec[]
M.portal_mappings = {
  { '[j', '<cmd>Portal jumplist backward<cr>', desc = 'portal backward' },
  { ']j', '<cmd>Portal jumplist forward<cr>', desc = 'portal forward' },
}

---@type LazyKeysSpec[]
M.grapple_mappings = {
  { '<leader>mm', '<cmd>Grapple toggle<cr>', desc = 'Grapple toggle tag' },
  { '<leader>M', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple open tags window' },
  { 'H', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple - next tag' },
  { 'L', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple - previous tag' },
  { '<leader>1', '<cmd>Grapple select index=1<cr>', desc = 'Select first tag' },
  { '<leader>2', '<cmd>Grapple select index=2<cr>', desc = 'Select second tag' },
  { '<leader>3', '<cmd>Grapple select index=3<cr>', desc = 'Select third tag' },
  { '<leader>4', '<cmd>Grapple select index=4<cr>', desc = 'Select fourth tag' },
}

---@type LazyKeysSpec[]
M.neogen_mappings = {
  { '<leader>ng', ":lua require('neogen').generate()<CR>", { desc = '[N]eogen [F]unction' } },
}

---@type LazyKeysSpec[]
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

  -- Git blame
  nmap { '<leader>gb', ':Git blame<CR>', { desc = '[G]it [B]lame' } }
end

---@type LazyKeysSpec[]
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

---@type LazyKeysSpec[]
M.diffview_mappings = {
  { '<leader>gv', '<cmd>DiffviewFileHistory %<CR>', desc = '[G]it [V]iew (:gitv! alt)' },
  { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = '[G]it [D]iff' },
}

---@type LazyKeysSpec[]
M.ripgrep_mappings = {
  --  alias for above
  --  Grep project for selection with Rg
  { '<leader>rg', 'y :Rg "<CR>', mode = 'v', desc = '[R]ip[G]rep selection' },
  --  Grep project for word under the cursor with Rg
  { '<Leader>rg', ':Rg <C-r><C-w><CR>', desc = '[R]ip[G]rep word under cursor' },
}

---@type LazyKeysSpec[]
M.easy_align_mappings = {
  { '<leader>ea', ':EasyAlign ', desc = '[E]asy [A]lign' },
  { '<leader>ea', ':EasyAlign ', mode = 'v', desc = '[E]asy [A]lign' },
}

---@type LazyKeysSpec[]
M.vim_test_mappings = {
  { '<leader>tn', ':TestNearest<CR>', silent = true, desc = '[T]est [N]earest' },
  { '<leader>tf', ':TestFile<CR>', silent = true, desc = '[T]est [F]ile' },
  { '<leader>ts', ':TestSuite<CR>', silent = true, desc = '[T]est [S]uite' },
  { '<leader>tl', ':TestLast<CR>', silent = true, desc = '[T]est [L]ast' },
}

---@type LazyKeysSpec[]
M.vimux_mappings = {
  { '<leader>rr', '<CMD>VimuxPromptCommand<CR>', desc = 'run a command (prompt)' },
  { '<leader>r.', '<CMD>VimuxRunLastCommand<CR>', desc = 'run the last run command' },
  { '<leader>rc', '<CMD>VimuxClearTerminalScreen<CR>', desc = 'clear the current run terminal' },
  { '<leader>rq', '<CMD>VimuxCloseRunner<CR>', desc = 'close the runner' },
  { '<leader>r?', '<CMD>VimuxInspectRunner<CR>', desc = 'inspect the runner' },
  { '<leader>r!', '<CMD>VimuxInterruptRunner<CR>', desc = "interrupt the runner (bang'er)" },
  { '<leader>rz', '<CMD>VimuxZoomRunner<CR>', desc = 'zoom the runner' },
  {
    '<C-c><C-c>',
    function()
      -- yank text into v register
      if vim.api.nvim_get_mode()['mode'] == 'n' then
        vim.cmd 'normal vip"vy'
      else
        vim.cmd 'normal "vy'
      end

      -- construct command with v register as command to send
      -- vim.cmd(string.format('call VimuxRunCommand("%s")', vim.trim(vim.fn.getreg('v'))))
      vim.cmd 'call VimuxRunCommand(@v)'
    end,
    desc = 'run command under cursor',
  },
}

---@type LazyKeysSpec[]
M.undotree_mappings = {
  { '<leader>ut', '<cmd>UndotreeToggle<CR>', desc = '[U]ndo [T]ree' },
}

local attempt = function(fun)
  return function()
    require('attempt')[fun]()
  end
end

---@type LazyKeysSpec[]
M.attempt_mappings = {
  -- new attempt, selecting extension
  { '<leader>sn', attempt 'new_select', desc = '[S]cratch [N]ew' },
  -- run current attempt buffer
  { '<leader>sr', attempt 'run', desc = '[S]cratch [R]un' },
  -- delete attempt from current buffer
  { '<leader>sd', attempt 'delete_buf', desc = '[S]cratch [D]elete (current buffer)' },
  -- rename attempt from current buffer
  { '<leader>sc', attempt 'rename_buf', desc = '[S]cratch Rename (current buffer)' },
  -- open one of the existing scratch buffers
  { '<leader>sl', '<cmd>Telescope attempt<CR>', desc = '[S]cratch [L]oad' },
}

---@type LazyKeysSpec[]
-- stylua: ignore
M.snack_mappings = {
  -- picker
  { "<leader>,", picker('buffers'), desc = "Buffers" },
  { "<leader>/", picker('grep'), desc = "Grep" },
  { "<leader>:", picker('command_history'), desc = "Command History" },
  { '<leader>pp', picker('registers'), desc = "Registers" },
  { '<leader>fi', picker('icons'), desc = '[F]ind [I]cons' },
  { '<leader>fu', picker('undo'), desc = '[F]ind [U]ndo' },
  { '<leader>lg', picker('grep', {need_search = false}), desc = '[L]ive [G]rep' },
  { '<leader>fw', picker('grep_word'), desc = '[F]ind [W]ord' },
  { '<leader>fd', picker('files', {cwd = '~/dotfiles'}), desc = '[F]ind [D]otfiles' },
  { '<leader>f/', picker('grep_buffers'), desc = 'Buffer fuzzy find' },
  { '<leader>f:', picker('commands'), desc = 'Command search' },
  { '<leader>f;', picker('command_history'), desc = 'Command History' },
  { '<leader>f?', picker('search_history'), desc = 'Search History' },
  { '<leader>ff', picker('files'), desc = '[F]ind [F]iles' },
  { '<leader>fg', picker('grep', {need_search = false}), desc = '[F]ind w/ [G]rep' },
  { '<leader>fh', picker('help'), desc = '[F]ind [H]elp' },
  { '<leader>fk', picker('keymaps'), desc = '[F]ind [K]eymaps' },
  { '<leader>fs', picker('git_status'), desc = '[F]ind (Git) [S]tatus' },
  { '<leader>bb', picker('buffers'), desc = 'Find Buffers' },
  { '<leader>fb', picker('explorer'), desc = '[F]ile [B]rowser' },
  -- bc = buffer commits (like gitv!)
  { '<leader>bc', picker('git_log_file'), desc = '[B]uffer [C]ommits' },
  { '<leader>bh', picker('git_log_file'), desc = '[B]uffer [H]istory' },

  { '<leader>nt', picker('explorer', {follow_file = false}), { desc = '[N]erdTree (not really) [T]oggle' } },
  { '<leader>nf', picker('explorer', {follow_file = true}), { desc = '[N]erdTree (not really) [F]ile (toggle)' } },
  { '<leader>tt', picker('explorer'), { desc = '[T]ree [T]oggle' } },

  -- muscle memory
  { '<C-p>', picker('files'), desc = 'Find Files' },
  { '<C-b>', picker('buffers'), desc = 'Find Buffers' },

  -- insert mode pickers
  { '<C-q>', picker('icons'), mode = 'i', desc = 'Insert Icon', },

  -- better spell suggestions
  { 'z=', picker('spelling'), desc = 'Spelling Suggestions' },

  -- LSP
  { '<leader>ds', picker('lsp_symbols'), desc = '[D]ocument [S]ymbols' },
  { 'gd', picker('lsp_definitions'), desc = '[G]o to [d]efinition' },
  { 'gr', picker('lsp_references'), desc = '[G]o to [R]eferences' },
  { '<leader>cc', picker('pick', require('plugins.snacks.conventional_commits_picker')), desc = '[C]onventional [C]ommits' },

  -- scratch
  { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
  { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },

  -- zen
  { '<leader>zm', function() Snacks.zen() end, desc = 'Zen Mode (Toggle)' },

  -- notifier
  { '<leader>nd', function() Snacks.notifier.hide() end, desc = 'Notification Dismiss' },
  { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },

  -- bufdelete
  { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
  { '<leader>bD', function() Snacks.bufdelete({ force = true }) end, desc = 'Delete Buffer (Force)' },
  { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete Other Buffers' },
  { '<leader>bO', function() Snacks.bufdelete.other({ force = true }) end, desc = 'Delete Other Buffers (Force)' },

  -- git
  { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
  { "<leader>bl", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
  { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
  { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
  { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },

  -- LSP
  { "<leader>rf", function() Snacks.rename.rename_file() end, desc = "Rename File" },
  { "]r",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
  { "[r",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },
}

---@type LazyKeysSpec[]
M.gitsigns_mappings = {

  -- Navigation
  {
    ']h',
    function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        require('gitsigns').nav_hunk 'next'
      end
    end,
    desc = 'Next Hunk',
  },

  {
    '[h',
    function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        require('gitsigns').nav_hunk 'prev'
      end
    end,
    desc = 'Prev Hunk',
  },

  -- Actions
  {
    '<leader>hs',
    function()
      require('gitsigns').stage_hunk()
    end,
    desc = 'Stage Hunk',
    mode = 'n',
  },
  {
    '<leader>hr',
    function()
      require('gitsigns').reset_hunk()
    end,
    desc = 'Reset Hunk',
    mode = 'n',
  },
  {
    '<leader>hs',
    function()
      require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end,
    desc = 'Stage Hunk',
    mode = 'v',
  },
  {
    '<leader>hr',
    function()
      require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end,
    desc = 'Reset Hunk',
    mode = 'v',
  },
  {
    '<leader>hS',
    function()
      require('gitsigns').stage_buffer()
    end,
    desc = 'Stage Buffer',
    mode = 'n',
  },
  {
    '<leader>hR',
    function()
      require('gitsigns').reset_buffer()
    end,
    desc = 'Reset Buffer',
    mode = 'n',
  },
  {
    '<leader>hp',
    function()
      require('gitsigns').preview_hunk()
    end,
    desc = 'Preview Hunk',
    mode = 'n',
  },
  {
    '<leader>hi',
    function()
      require('gitsigns').preview_hunk_inline()
    end,
    desc = 'Preview Hunk Inline',
    mode = 'n',
  },
  {
    '<leader>hb',
    function()
      require('gitsigns').blame_line { full = true }
    end,
    desc = 'Blame Line',
    mode = 'n',
  },
  {
    '<leader>hd',
    function()
      require('gitsigns').diffthis()
    end,
    desc = 'Diff This',
    mode = 'n',
  },
  {
    '<leader>hD',
    function()
      require('gitsigns').diffthis '~'
    end,
    desc = 'Diff This (~)',
    mode = 'n',
  },
  {
    '<leader>hQ',
    function()
      require('gitsigns').setqflist 'all'
    end,
    desc = 'Git Hunks to QF List (All)',
    mode = 'n',
  },
  {
    '<leader>hq',
    function()
      require('gitsigns').setqflist(0)
    end,
    desc = 'Git Hunks to QF List (Buffer)',
    mode = 'n',
  },
  -- Toggles
  {
    '<leader>tb',
    function()
      require('gitsigns').toggle_current_line_blame()
    end,
    desc = 'Toggle Current Line Blame',
    mode = 'n',
  },
  {
    '<leader>tw',
    function()
      require('gitsigns').toggle_word_diff()
    end,
    desc = 'Toggle Word Diff',
    mode = 'n',
  },
  -- Text object for git hunks (e.g. vih will select the hunk)
  { 'ih', ':<C-U>Gitsigns select_hunk<CR>', mode = { 'o', 'x' }, desc = '[I]n [H]unk' },
}

nmap {
  '<leader>dx',
  require('core.utils').delete_comments_in_buffer,
  { noremap = true, silent = true, desc = 'Delete all comments' },
}

return M
