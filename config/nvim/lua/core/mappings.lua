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

---Convenience shorthand for lazy calling picker
---@param fun string the picker function to use
---@param opts table? options to pass to the picker function
---@return function
local picker = function(fun, opts)
  if opts == nil then
    opts = {}
  end

  return function()
    Snacks.picker[fun](opts)
  end
end

---Convenience shorthand for calling tmux seamless navigator plugin
---@param fun string the function to call
---@return function
local tmux = function(fun)
  return function()
    require('tmux')[fun]()
  end
end

local silent = { silent = true }

-- a more useful gf
nmap { 'gf', 'gF', { desc = 'Go to file under cursor', silent = true } }

-- center window on search result
nmap { 'n', 'nzzzv' }
nmap { 'N', 'Nzzzv' }

-- rename current file
nmap { '<Leader>mv', ":Move <C-R>=expand('%')<CR>", { desc = 'Move current file' } }

-- copy current file
nmap { '<Leader>sa', ":saveas <C-R>=expand('%')<CR><Left><Left><Left>", { desc = '[S]ave [A]s current file' } }

-- remove highlighting on escape
nmap { '<esc>', ':nohlsearch<cr>', silent }

nmap { '<leader>ll', ':lua ', desc = '[L]aunch [L]ua' }

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

--  Navigate neovim + tmux with ctrl+direction
vmap { '<C-h>', tmux 'move_left', { desc = 'Move to left pane' } }
vmap { '<C-j>', tmux 'move_bottom', { desc = 'Move to bottom pane' } }
vmap { '<C-k>', tmux 'move_top', { desc = 'Move to top pane' } }
vmap { '<C-l>', tmux 'move_right', { desc = 'Move to right pane' } }

--  Navigate neovim + neovim terminal emulator + tmux with ctrl+direction
tmap { '<C-h>', tmux 'move_left' }
tmap { '<C-j>', tmux 'move_bottom' }
tmap { '<C-k>', tmux 'move_top' }
tmap { '<C-l>', tmux 'move_right' }

-- easily escape terminal
tmap { '<esc><esc>', '<C-\\><C-n><esc><cr>' }
tmap { '<C-o>', '<C-\\><C-n><esc><cr>' }

-- resize windows with alt+hjkl in terminal mode (matches tmux behavior)
tmap {
  '<M-h>',
  function()
    require('core.tmux_resizer').resize_left()
    vim.cmd 'startinsert'
  end,
  silent,
}
tmap {
  '<M-j>',
  function()
    require('core.tmux_resizer').resize_down()
    vim.cmd 'startinsert'
  end,
  silent,
}
tmap {
  '<M-k>',
  function()
    require('core.tmux_resizer').resize_up()
    vim.cmd 'startinsert'
  end,
  silent,
}
tmap {
  '<M-l>',
  function()
    require('core.tmux_resizer').resize_right()
    vim.cmd 'startinsert'
  end,
  silent,
}

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
vmap { '<S-Up>', ":move '<-2<CR>gv=gv", { desc = 'Move selection up' } }
vmap { '<S-Down>', ":move '>+1<CR>gv=gv", { desc = 'Move selection down' } }

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
  nmap { '<leader>D', vim.lsp.buf.type_definition, { buffer = true, desc = 'Type [D]ef' } }
  map { { 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = true, desc = '[C]ode [A]ction' } }
  nmap { 'K', vim.lsp.buf.hover, { buffer = true, desc = 'LSP Hover Doc' } }
  nmap { '<leader>rn', vim.lsp.buf.rename, { buffer = true, desc = '[R]e[n]ame Symbol Under Cursor' } }
  nmap { '<Leader>lh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = "toggle in[l]ay [h]ints" }}
end

M.lsp_diagnostic_mappings = function()
  local function diagnostic_goto(next, severity)
    local goto_next = function()
      vim.diagnostic.jump { count = 1, severity = severity }
    end

    local goto_prev = function()
      vim.diagnostic.jump { count = -1, severity = severity }
    end

    return next and goto_next or goto_prev
  end

  nmap { ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' } }
  nmap { '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' } }
  nmap { ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' } }
  nmap { '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' } }
  nmap { ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' } }
  nmap { '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' } }

  nmap { '<leader>qd', '<cmd>lua vim.diagnostic.setloclist()<CR>', { desc = 'Set loclist to LSP diagnostics' } }
end

-- stylua: ignore
M.elixir_mappings = function()
  nmap { '<space>fp', ':ElixirFromPipe<cr>', { desc = '[F]rom [P]ipe', buffer = true, noremap = true } }
  nmap { '<space>tp', ':ElixirToPipe<cr>', { desc = '[T]o [P]ipe', buffer = true, noremap = true } }
  nmap { '<space>tm', ':ElixirToggleMapKeys<cr>', { desc = '[T]oggle [M]ap Keys', buffer = true, noremap = true } }
  nmap { '<space>tM', ':ElixirToggleMapKeys!<cr>', { desc = '[T]oggle [M]ap Keys (deep)', buffer = true, noremap = true } }
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
    '<leader>sx',
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
  { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                              desc = "Todo (Trouble)" },
  { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
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
    mode = { 'n', 'v' },
    function()
      require('oil').toggle_float()
    end,
    desc = 'Open parent directory (float)',
  },
}

---Private function to handle Yazi toggle from Oil buffers
---@private
local yazi_toggle = function()
  -- Check if we're in an Oil buffer
  if vim.bo.filetype == 'oil' and require('oil').get_current_dir() then
    -- Call Yazi with the actual directory path from Oil
    require('yazi').yazi({}, require('oil').get_current_dir())
  else
    -- Normal Yazi call for non-Oil buffers
    vim.cmd 'Yazi'
  end
end

---@type LazyKeysSpec[]
M.yazi_nvim_mappings = {
  { '<leader>\\', yazi_toggle, { desc = 'Open parent directory' } },
  { '<leader>|', '<cmd>Yazi cwd<CR>', { desc = 'Open CWD' } },
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
  { '<leader>ng', ":lua require('neogen').generate()<CR>", desc = 'Generate Annotation (NeoGen)' },
}

-- stylua: ignore
---@type LazyKeysSpec[]
M.opencode_mappings = {
  { "<leader>ot", function() require("opencode").ask("@this: ", { submit = true }) end, mode = { "n", "x" }, desc = "Ask opencode"},
  { "<leader>oa", function() require("opencode").prompt("@this") end, mode = { "n", "x" }, desc = "Add to opencode"},
  { "<leader>os", function() require("opencode").select() end, mode = { "n", "x" }, desc = "Select opencode action"},
  { "<leader>oc", function() require("opencode").toggle() end, desc = "Toggle opencode"},
}

---@type LazyKeysSpec[]
M.claudecode_mappings = {
  { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
  { '<leader>aa', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
  { '<leader>aa', 'V<cmd>ClaudeCodeSend<cr>', mode = 'n', desc = 'Send line to Claude' },
  {
    '<leader>as',
    '<cmd>ClaudeCodeTreeAdd<cr>',
    desc = 'Add file',
    ft = { 'oil' },
  },
  -- Diff management
  { '<leader>ay', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff (y)' },
  { '<leader>an', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff (n)' },
}

M.fugitive_mappings = function()
  -- Git Stage file
  nmap { '<leader>gS', ':Gwrite<CR>', { silent = true, desc = '[G]it [S]tage' } }
  nmap { '<leader>gw', ':Gwrite<CR>', { silent = true, desc = '[G]it [W]rite' } }

  --  Revert file
  nmap { '<Leader>gR', ':Gread<CR>', { silent = true, desc = '[G]it [R]ead (reverts file)' } }
end

---@type LazyKeysSpec[]
M.blame_mappings = {
  -- Git blame
  { '<leader>gb', '<cmd>BlameToggle<CR>', silent = true, desc = '[G]it [B]lame' },
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
  { '<leader>rp', '<CMD>VimuxPromptCommand<CR>', desc = 'run a command (prompt)' },
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
      vim.cmd 'call VimuxRunCommand(@v)'
    end,
    desc = 'run command under cursor',
  },
  {
    '<leader>rr',
    function()
      -- yank text into v register
      if vim.api.nvim_get_mode()['mode'] == 'n' then
        vim.cmd 'normal V"vy'
      else
        vim.cmd 'normal "vy'
      end

      -- construct command with v register as command to send
      vim.cmd 'call VimuxRunCommand(@v)'
    end,
    desc = 'run command under cursor',
  },
  {
    '<leader>!',
    function()
      vim.o.operatorfunc = "v:lua.require'core.mappings'.vimux_operator"
      return 'g@'
    end,
    expr = true,
    desc = 'run motion selection with vimux',
  },
  {
    '<leader>!!',
    function()
      vim.o.operatorfunc = "v:lua.require'core.mappings'.vimux_operator"
      return 'g@ip'
    end,
    expr = true,
    desc = 'run current paragraph with vimux',
  },
}

-- Function to handle vimux operator motions
function M.vimux_operator(motion_type)
  local saved_reg = vim.fn.getreg 'v'
  local saved_regtype = vim.fn.getregtype 'v'

  if motion_type == 'char' then
    vim.cmd 'normal! `[v`]"vy'
  elseif motion_type == 'line' then
    vim.cmd 'normal! `[V`]"vy'
  elseif motion_type == 'block' then
    vim.cmd 'normal! `[<C-v>`]"vy'
  end

  local content = vim.fn.getreg 'v'

  -- Check if content is a markdown codeblock
  local lines = vim.split(content, '\n')

  -- Find the closing backticks (could be last line or second-to-last if there's trailing newline)
  local closing_line_idx = #lines
  if lines[#lines] == '' and #lines > 1 then
    closing_line_idx = #lines - 1
  end

  if #lines > 2 and lines[1]:match '^```.*$' and lines[closing_line_idx]:match '^```%s*$' then
    -- Extract code content (remove first and closing backtick lines)
    local code_lines = {}
    for i = 2, closing_line_idx - 1 do
      table.insert(code_lines, lines[i])
    end
    content = table.concat(code_lines, '\n')
  end

  -- Set the processed content to the v register and run
  vim.fn.setreg('v', content)
  vim.cmd 'call VimuxRunCommand(@v)'

  vim.fn.setreg('v', saved_reg, saved_regtype)
end

---@type LazyKeysSpec[]
M.undotree_mappings = {
  { '<leader>ut', '<cmd>UndotreeToggle<CR>', desc = '[U]ndo [T]ree' },
}

M.grug_far_mappings = {
  {
    '<leader>fr',
    function()
      local grug = require 'grug-far'
      local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
      grug.open {
        transient = true,
        prefills = {
          filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
        },
      }
    end,
    mode = { 'n', 'v' },
    desc = 'Search and Replace',
  },
}

local attempt = function(fun)
  return function()
    require('attempt')[fun]()
  end
end

-- stylua: ignore
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
  { '<leader>sf', function() require('attempt.snacks').picker() end, desc = '[S]cratch [F]ind' },
}

local git_copy_file_url = function()
  ---@diagnostic disable-next-line: missing-fields
  Snacks.gitbrowse {
    open = function(url)
      -- gitbrowse doesn't support file link without lines, so I'm setting the
      -- line range to 0-0 and stripping it before copying to sys clipboard
      url = url:gsub('#L0%-L0$', '')
      vim.fn.setreg('+', url)
    end,
    notify = false,
    line_start = 0,
    line_end = 0,
  }
  vim.notify('Copied ' .. vim.fn.getreg '+', vim.log.levels.INFO)
end

local git_copy_line_url = function()
  ---@diagnostic disable-next-line: missing-fields
  Snacks.gitbrowse {
    open = function(url)
      vim.fn.setreg('+', url)
    end,
    notify = false,
  }
  vim.notify(vim.fn.getreg '+', vim.log.levels.INFO, { title = 'Copied' })
end

---@type LazyKeysSpec[]
-- stylua: ignore
M.snack_mappings = {
  -- picker
  { "<leader>,", picker('buffers'), desc = "Buffers" },
  { "<leader>/", picker('lines'), desc = "Fuzzy Buffer Lines" },
  { "<leader>:", picker('command_history'), desc = "Command History" },
  { '<leader>fi', picker('icons'), desc = '[F]ind [I]cons' },
  { '<leader>fu', picker('undo'), desc = '[F]ind [U]ndo' },
  { '<leader>lg', picker('grep', {need_search = false}), desc = '[L]ive [G]rep' },
  { '<leader>fw', picker('grep_word'), mode = {'n', 'v'}, desc = '[F]ind [W]ord' },
  { '<leader>fd', picker('files', {cwd = '~/dotfiles'}), desc = '[F]ind [D]otfiles' },
  {'<leader>fgd', picker('git_diff'), desc = '[F]ind [G]it [D]iff' },
  { '<leader>f:', picker('commands'), desc = 'Command search' },
  { '<leader>f;', picker('command_history'), desc = 'Command History' },
  { '<leader>f?', picker('search_history'), desc = 'Search History' },
  { '<leader>ff', picker('files', {hidden = true}), desc = '[F]ind [F]iles' },
  { '<leader>fe', picker('files', {args = {'-e=ex', '-e=exs', '-e=heex'}}), desc = '[F]ind [E]lixir' },
  { '<leader>ft', picker('files', {args = {'-e=ts', '-e=tsx', '-e=js', '-e=jsx', '-e=json'}}), desc = '[F]ind [T]ypeScript' },
  { '<leader>fl', picker('files', {args = {'-e=lua'}}), desc = '[F]ind [L]ua' },
  { '<leader>fg', picker('grep', {hidden = true, need_search = false}), desc = '[F]ind w/ [G]rep' },
  { '<leader>fh', picker('help'), desc = '[F]ind [H]elp' },
  { '<leader>fk', picker('keymaps'), desc = '[F]ind [K]eymaps' },
  {'<leader>fp', picker('pr_files'), desc = "[F]ind [P]R files"},
  { '<leader>fs', picker('git_status'), desc = '[F]ind (Git) [S]tatus' },
  { '<leader>fc', picker('git_status', {pattern = "UU"}), desc = '[F]ind (Git) [C]onflict' },
  { '<leader>bb', picker('buffers'), desc = 'Find Buffers' },
  { '<leader>fb', picker('explorer'), desc = '[F]ile [B]rowser' },
  { '<leader>fo', picker('recent', {filter = {cwd = true, paths = {['.git/COMMIT_EDITMSG'] = false}}}), desc = '[F]ile [O]ld files' },
  -- bc = buffer commits (like gitv!)
  { '<leader>bc', picker('git_log_file'), desc = '[B]uffer [C]ommits' },
  { '<leader>bh', picker('git_log_file'), desc = '[B]uffer [H]istory' },

  { '<leader>nt', picker('explorer', {follow_file = false}), { desc = '[N]erdTree (not really) [T]oggle' } },
  { '<leader>nf', picker('explorer', {follow_file = true}), { desc = '[N]erdTree (not really) [F]ile (toggle)' } },
  { '<leader>tt', picker('explorer'), { desc = '[T]ree [T]oggle' } },
  {'<leader>f<CR>', picker('resume'), desc = 'Finder Resume'},

  {'<leader>ls', picker('lsp_config'), desc = '[L]SP [S]ettings'},

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
  { 'gD', picker('lsp_declarations'),  desc = '[G]o to [D]ecleration' },
  { 'gr', picker('lsp_references'), desc = '[G]o to [R]eferences' },
  { 'gi', picker('lsp_implementations', {
      filter = {
        filter = function(item, _filter)
          -- exclude defdelegates from results, so we can jump directly to the
          -- real impl
          return not item.text:match("defdelegate")
        end
    },
  }), desc = '[G]o to [I]mplementation' },
  { '<leader>cc', picker('pick', require('plugins.snacks.conventional_commits_picker')), desc = '[C]onventional [C]ommits' },

  -- scratch
  { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
  { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },

  -- zen
  { '<leader>zm', function() Snacks.zen() end, desc = 'Zen Mode (Toggle)' },

  -- notifier
  { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
  { '<leader>nd', function() Snacks.notifier.hide() end, desc = 'Notification Dismiss' },
  { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Dismiss All Notifications" },

  -- bufdelete
  { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
  { '<leader>bD', function() Snacks.bufdelete({ force = true }) end, desc = 'Delete Buffer (Force)' },
  { '<leader>bo', function() Snacks.bufdelete.other(); vim.notify('Deleted all other buffers') end, desc = 'Delete Other Buffers' },
  { '<leader>bO', function() Snacks.bufdelete.other({ force = true }); vim.notify('Deleted all other buffers') end, desc = 'Delete Other Buffers (Force)' },

  -- git
  { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
  { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
  { "<leader>gY", git_copy_file_url, mode = { "n", "x" }, desc = "Git Copy File URL"},
  { "<leader>gy", git_copy_line_url, mode = { "n", "x" }, desc = "Git Copy Line(s) URL"},
  -- open github page for file
  { '<leader>gO', function() Snacks.gitbrowse({line_start = 0, line_end = 0}) end, desc = '[G]ithub [O]pen File' },
  -- open github page for line under cursor / selection
  { '<leader>go', function() Snacks.gitbrowse() end, mode = {'n', 'v'}, desc = '[G]ithub [o]pen Line' },

  -- github
  { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
  { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
  { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
  { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },

  -- lazygit
  { "<leader>gl", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
  { "<leader>gL", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },

  -- LSP
  { "<leader>rf", function() Snacks.rename.rename_file() end, desc = "Rename File" },
  { "]r",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
  { "[r",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },
  { "gai", picker('lsp_incoming_calls'), desc = "C[a]lls Incoming" },
  { "gao", picker('lsp_outgoing_calls'), desc = "C[a]lls Outgoing" },
  { "<leader>ss", picker('lsp_symbols'), desc = "LSP Symbols" },
  { "<leader>sS", picker('lsp_workspace_symbols'), desc = "LSP Workspace Symbols" },


  -- Grep
  { "<leader>sg", picker('grep'), desc = "Grep" },
  { "<leader>sw", picker('grep_word'), desc = "Visual selection or word", mode = { "n", "x" } },
  -- search
  { '<leader>s"', picker('registers'), desc = "Registers" },
  { '<leader>s/', picker('search_history'), desc = "Search History" },
  { "<leader>sA", picker('autocmds'), desc = "Autocmds" },
  { "<leader>sb", picker('lines'), desc = "Buffer Lines" },
  { "<leader>sB", picker('grep_buffers'), desc = "Grep Open Buffers" },
  { "<leader>sc", picker('command_history'), desc = "Command History" },
  { "<leader>sC", picker('commands'), desc = "Commands" },
  { "<leader>sd", picker('diagnostics'), desc = "Diagnostics" },
  { "<leader>sD", picker('diagnostics_buffer'), desc = "Buffer Diagnostics" },
  { "<leader>sh", picker('help'), desc = "Help Pages" },
  { "<leader>sH", picker('highlights'), desc = "Highlights" },
  { "<leader>si", picker('icons'), desc = "Icons" },
  { "<leader>sj", picker('jumps'), desc = "Jumps" },
  { "<leader>sk", picker('keymaps'), desc = "Keymaps" },
  { "<leader>sl", picker('loclist'), desc = "Location List" },
  { "<leader>sm", picker('marks'), desc = "Marks" },
  { "<leader>sM", picker('man'), desc = "Man Pages" },
  { "<leader>sp", picker('lazy'), desc = "Search for Plugin Spec" },
  { "<leader>sq", picker('qflist'), desc = "Quickfix List" },
  { "<leader>sR", picker('resume'), desc = "Resume" },
  { "<leader>su", picker('undo'), desc = "Undo History" },
  { "<leader>uC", picker('colorschemes'), desc = "Colorschemes" },
  -- Other
  { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
  { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
  { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
  { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
  { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
  { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
  { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
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
    '<leader>bL',
    function()
      require('gitsigns').blame_line { full = true }
    end,
    desc = 'Blame Line (full)',
    mode = 'n',
  },
  {
    '<leader>bl',
    function()
      require('gitsigns').blame_line()
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
