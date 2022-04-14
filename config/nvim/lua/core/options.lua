-- move to options.lua
local opt = vim.opt
local g = vim.g

-- support syntax highlighting

vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")  -- try to recognize filetypes and load rel' plugins

-- vim, not vi (wonder if this is still necessary in neovim)
opt.compatible = false

-- use system clipboard by default
opt.clipboard = "unnamedplus"

opt.hidden = true --  enable hidden unsaved buffers

opt.termguicolors = true --  enable true colors

opt.smartcase = true -- use case sensitive if capital letter present or \C
opt.ignorecase = true -- ignore case in searches
opt.incsearch = true -- do incremental searching
opt.magic = true -- Use 'magic' patterns (extended regular expressions).

opt.mouse = "a" -- enable mouse usage

opt.cursorline = true -- highlight the current line


-- keep indentation consistent
local indent = 2
opt.tabstop     = indent      -- Softtabs or die! use 2 spaces for tabs.
opt.shiftwidth  = indent   -- Number of spaces to use for each step of (auto)indent.
opt.softtabstop = indent
opt.expandtab   = true  --  Use the spaces to insert a <Tab>
opt.shiftround  = true -- Round indent to multiple of 'shiftwidth'
opt.smartindent = true

-- text appearance
opt.textwidth = 80                      --  set row width size in    charcters
opt.wrap      = false
opt.list      = true                    --  show invisible characters
opt.listchars = "tab:»·,trail:·,nbsp:·" --  Display        extra   whitespace

-- line numbers
opt.number      = true
opt.numberwidth = 2
opt.ruler = false -- status line will already show the ruler (line and column number of the cursor position)

-- always show the sign column
opt.signcolumn = "yes"

-- Open new split panes to right and bottom, which feels more natural
opt.splitbelow = true
opt.splitright = true


-- disable tilde on end of buffer: https://github.com/neovim/neovim/pull/8546#issuecomment-643643758
opt.fillchars = { eob = " " }

-- used by a bunch of plugins to perform async actions (e.g. gitsigns)
-- when the user stopped typing. Also used by vim to decide when
-- to write a swp file.
opt.updatetime = 100

-- should make scrolling faster
opt.ttyfast    = true
opt.lazyredraw = true

-- set leader key to `\`
g.mapleader = "\\"
-- TODO: add aliases to space
-- " alias for leader key
--  nmap <space> \
--  xmap <space> \

opt.backspace  = "indent,eol,start"  -- Backspace deletes like most programs in insert mode
opt.history    = 200       -- how many : commands to save in history
opt.showcmd    = true           -- display incomplete commands
opt.laststatus = 2      -- Always display the status line
opt.autowrite  = true        -- Automatically :write before running commands
opt.showmode   = false       -- don't show mode as airline already does
opt.showcmd    = true           -- show any commands
opt.foldmethod = "manual" -- set folds by syntax of current language
opt.visualbell = true -- visual bell for errors
opt.redrawtime = 5000   -- prevent vim from disabling highliting if the code is complex

-- colors
g.gruvbox_transparent = 1
vim.cmd("colorscheme one")

--Defer loading shada until after startup_
local shadafile = opt.shadafile
opt.shadafile = "NONE"

vim.schedule(function()
   vim.opt.shadafile = shadafile
   vim.cmd [[ silent! rsh ]]
end)
