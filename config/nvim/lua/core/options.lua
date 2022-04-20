-- configure general vim settings here
local opt = vim.opt
local g = vim.g

-- support syntax highlighting
vim.cmd("syntax enable")
-- try to recognize filetypes and load rel' plugins
vim.cmd("filetype plugin indent on")

-- vim, not vi (wonder if this is still necessary in neovim)
opt.compatible = false

opt.hidden = true --  enable hidden unsaved buffers
opt.termguicolors = true --  enable true colors
opt.cursorline = true -- highlight the current line

-- search
opt.smartcase = true -- use case sensitive if capital letter present or \C
opt.ignorecase = true -- ignore case in searches
opt.incsearch = true -- do incremental searching
opt.magic = true -- Use 'magic' patterns (extended regular expressions).

opt.mouse = "a" -- enable mouse usage

-- keep indentation consistent
local indent = 2
opt.tabstop = indent -- Softtabs or die! use 2 spaces for tabs.
opt.shiftwidth = indent -- Number of spaces to use for each step of (auto)indent.
opt.softtabstop = indent
opt.expandtab = true --  Use the spaces to insert a <Tab>
opt.shiftround = true -- Round indent to multiple of 'shiftwidth'
opt.smartindent = true

-- text appearance
opt.textwidth = 80 --  set row width size in    charcters
opt.wrap = false
opt.list = true --  show invisible characters
opt.listchars = "tab:»·,trail:·,nbsp:·" --  Display        extra   whitespace

-- line numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false -- status line will already show the ruler (line and column number of the cursor position)

-- always show the sign column
opt.signcolumn = "yes"

-- Open new split panes to right and bottom, which feels more natural
opt.splitbelow = true
opt.splitright = true

-- disable tilde on end of buffer: https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
-- opt.fillchars = { eob = " " }

-- used by a bunch of plugins to perform async actions (e.g. gitsigns)
-- when the user stopped typing. Also used by vim to decide when
-- to write a swp file.
opt.updatetime = 100

-- should make scrolling faster
opt.ttyfast = true
opt.lazyredraw = true

-- set leader key to `\`
g.mapleader = "\\"
-- TODO: add aliases to space
-- " alias for leader key
--  nmap <space> \
--  xmap <space> \

opt.backspace = "indent,eol,start" -- Backspace deletes like most programs in insert mode
opt.history = 200 -- how many : commands to save in history
opt.showcmd = true -- display incomplete commands
opt.laststatus = 2 -- Always display the status line
opt.autowrite = true -- Automatically :write before running commands
opt.showmode = false -- don't show mode as airline already does
opt.showcmd = true -- show any commands
opt.foldmethod = "manual" -- set folds by syntax of current language
opt.visualbell = true -- visual bell for errors
opt.redrawtime = 5000 -- prevent vim from disabling highliting if the code is complex

-- colors
vim.cmd("colorscheme one")

--Defer loading shada until after startup_
local shadafile = opt.shadafile
opt.shadafile = "NONE"

vim.schedule(function()
  vim.opt.shadafile = shadafile
  vim.cmd([[ silent! rsh ]])
end)

-- Make diffing better
-- https://vimways.org/2018/the-power-of-diff/
----------------------------------------------
-- Always use vertical diffs
opt.diffopt:append("vertical")
opt.diffopt:append("filler")
-- ignore whitespace
opt.diffopt:append("iwhite")
opt.diffopt:append("algorithm:patience")
opt.diffopt:append("indent-heuristic")
----------------------------------------------

-- Set spellfile to location that is guaranteed to exist, can be symlinked to
-- Dropbox or kept in Git
opt.spellfile = string.format("%s/.vim-spell-en.utf-8.add", vim.env.HOME)
local tmpdir = string.format("%s/.vim/tmp, ", vim.env.HOME)

-- set where swap file and undo/backup files are saved
opt.backupdir = tmpdir
opt.directory = tmpdir

-- persistent undo between file reloads
if vim.fn.has("persistent_undo") then
  opt.undofile = true
  opt.undodir = tmpdir
end

-- Autocomplete with dictionary words when spell check is on
opt.complete:append("kspell")

-- highlight fenced code blocks in markdown
g.markdown_fenced_languages = {
  "bash=sh",
  "elixir",
  "elm",
  "graphql",
  "html",
  "js=javascript",
  "json",
  "python",
  "ruby",
  "sql",
  "vim",
  "typescript",
  "yaml",
  "sshconfig",
  "cfg",
  "systemd",
  "nginx",
  "diff",
}

-- enable folding in bash files
g.sh_fold_enabled = 1

-- treat dash separated words as a word text object
opt.iskeyword:append("-")
