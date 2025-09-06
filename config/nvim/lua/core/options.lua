-- configure general vim settings here
local opt = vim.opt

opt.hidden = true --  enable hidden unsaved buffers
opt.termguicolors = true --  enable true colors
opt.cursorline = true -- highlight the current line
opt.confirm = true -- confirm to save changes before exiting modified buffer

-- search
opt.smartcase = true -- use case sensitive if capital letter present or \C
opt.ignorecase = true -- ignore case in searches
opt.incsearch = true -- do incremental searching
opt.magic = true -- Use 'magic' patterns (extended regular expressions).

opt.mouse = 'a' -- enable mouse usage

-- font for gui
vim.cmd [[set guifont=CaskaydiaCove\ Nerd\ Font\ Mono]]

-- keep indentation consistent (will be overwritten by vim-sleuth)
local indent = 2
opt.tabstop = indent -- Softtabs or die! use 2 spaces for tabs.
opt.shiftwidth = indent -- Number of spaces to use for each step of (auto)indent.
opt.softtabstop = indent
opt.expandtab = true --  Use the spaces to insert a <Tab>
opt.shiftround = true -- Round indent to multiple of 'shiftwidth'
-- this was messing up comments starting with `#`
-- see https://vim.fandom.com/wiki/Restoring_indent_after_typing_hash
opt.smartindent = false

-- automatically insert a comment leader if the previous line was a comment
opt.formatoptions:append 'r'

-- text appearance
-- set row width size in characters (will be overwritten by vim-sleuth)
-- this setting will automatically break lines when they exceed 'textwidth' during
-- insert mode. It does not affect existing lines, for that you can use gq.
-- To disable this feature: :set textwidth=0
opt.textwidth = 80
opt.wrap = false
opt.list = true -- show invisible characters
opt.listchars = 'tab:»·,trail:·,nbsp:·' --  Display extra whitespace

-- line numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false -- status line will already show the ruler (line and column number of the cursor position)

-- always show the sign column
opt.signcolumn = 'yes'

-- Open new split panes to right and bottom, which feels more natural
opt.splitbelow = true
opt.splitright = true

-- should make scrolling faster
opt.ttyfast = true

opt.backspace = 'indent,eol,start' -- Backspace deletes like most programs in insert mode
opt.history = 200 -- how many : commands to save in history
opt.showcmd = true -- display incomplete commands
opt.laststatus = 0 -- hide default status line
opt.autowrite = true -- Automatically :write before running commands
opt.showmode = false -- don't show mode as airline already does
opt.showcmd = true -- show any commands
opt.foldmethod = 'manual' -- set folds by syntax of current language
opt.visualbell = true -- visual bell for errors
opt.redrawtime = 5000 -- prevent vim from disabling highlighting if the code is complex

-- Make diffing better
-- https://vimways.org/2018/the-power-of-diff/
----------------------------------------------
-- Always use vertical diffs
opt.diffopt:append 'vertical'
opt.diffopt:append 'filler'
-- ignore whitespace
opt.diffopt:append 'iwhite'
opt.diffopt:append 'algorithm:patience'
opt.diffopt:append 'indent-heuristic'
----------------------------------------------

-- Set spellfile to location that is guaranteed to exist, can be symlinked to
-- Dropbox or kept in Git
opt.spellfile = string.format('%s/.vim-spell-en.utf-8.add', vim.env.HOME)
local tmpdir = string.format('%s/.cache/nvim/tmp, ', vim.env.HOME)
vim.opt_global.spell = true

-- set where swap file and undo/backup files are saved
opt.backupdir = tmpdir
opt.directory = tmpdir

-- persistent undo between file reloads
if vim.fn.has 'persistent_undo' then
  opt.undofile = true
  opt.undodir = tmpdir
end

-- Autocomplete with dictionary words when spell check is on
opt.complete:append 'kspell'

-- for nvim-cmp
opt.completeopt = { 'menu', 'menuone', 'noselect' }

opt.foldcolumn = '1'
opt.fillchars = {
  eob = '~',
  fold = ' ',
  foldopen = '',
  foldsep = '│',
  foldclose = '',
  -- solid window border
  vert = '│',
}

-- hide vertical split
vim.cmd 'highlight vertsplit guifg=fg guibg=bg'

opt.viewoptions:remove 'options'

-- treat dash separated words as a word text object
opt.iskeyword:append '-'

-- set pum background visibility to 20 percent
opt.pumblend = 20

-- set file completion in command to use pum
opt.wildoptions = 'pum'

-- interactive find replace preview
opt.inccommand = 'nosplit'

-- Use RipGrep for grep https://www.wezm.net/technical/2016/09/ripgrep-with-vim/
if vim.fn.executable 'rg' then
  opt.grepprg = 'rg --vimgrep --no-heading'
  opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
end

-- highlight the 80 character column
opt.colorcolumn = '80'

-- icons
local icons = require('core.utils').icons.diagnostics

vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.Error,
      [vim.diagnostic.severity.WARN] = icons.Warn,
      [vim.diagnostic.severity.INFO] = icons.Info,
      [vim.diagnostic.severity.HINT] = icons.Hint,
    },
  },
  underline = true,
  update_in_insert = false,
  virtual_lines = { current_line = true },
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
  },
}
