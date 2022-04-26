local present, packer = pcall(require, 'plugins.packer_init')

if not present then
  return false
end

return packer.startup(function(use)
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim' }

  -- Speed up loading Lua modules in Neovim to improve startup time.
  use { 'lewis6991/impatient.nvim' }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      -- LSP driven completions
      'hrsh7th/cmp-nvim-lsp',
      -- completion from buffer text
      'hrsh7th/cmp-buffer',
      -- file path completion
      'hrsh7th/cmp-path',
      -- command line completion
      'hrsh7th/cmp-cmdline',
      -- neovim lua config api completion
      'hrsh7th/cmp-nvim-lua',
      -- function signature help
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-emoji',
      -- snippet engine, required by cmp
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      -- git completions
      'petertriho/cmp-git',
    },
    config = function()
      require('plugins.cmp').setup()
    end,
  }

  -- Collection of configurations for the built-in LSP client
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'mhanberg/elixir.nvim',
      -- required by elixir plugin
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('plugins.lsp').setup()
    end,
  }

  --  pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('plugins.trouble').setup()
    end,
  }

  -- color schemes
  ----------------
  use {
    'folke/tokyonight.nvim',
    config = function()
      -- set colorscheme
      vim.g.tokyonight_transparent = true
      vim.g.tokyonight_dark_float = false
      vim.cmd [[colorscheme tokyonight]]
    end,
  }

  -- vim one (previous colorscheme, might still be useful)
  use { 'rakr/vim-one' }

  -- status line
  use {
    'feline-nvim/feline.nvim',
    requires = { 'lewis6991/gitsigns.nvim', 'kyazdani42/nvim-web-devicons' },
    after = 'nvim-web-devicons',
    config = function()
      require('feline').setup()
    end,
  }

  -- " Visual git gutter (also used by feline)
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('plugins.gitsigns').setup()
    end,
  }

  -- delete unused buffers
  use { 'schickling/vim-bufonly' }

  -- nginx syntax support
  use { 'chr4/nginx.vim' }

  -- run tests at the speed of thought
  use { 'janko-m/vim-test' }

  -- Highlight Yanked String
  use { 'machakann/vim-highlightedyank' }

  -- browse commit history for file
  use {
    'junegunn/gv.vim',
    requires = { 'tpope/vim-fugitive' },
  }

  -- git integration
  use { 'tpope/vim-fugitive' }

  -- github support for fugitive
  use {
    'tpope/vim-rhubarb',
    requires = { 'tpope/vim-fugitive' },
  }
  --  Better syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('plugins.treesitter').setup()
    end,
  }

  -- pretty buffers
  use {
    'akinsho/bufferline.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('plugins.bufferline').setup()
    end,
  }

  -- file tree
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('plugins.nvimtree').setup()
    end,
  }

  -- " Distraction free writing in vim
  use { 'junegunn/goyo.vim', cmd = 'Goyo' }

  -- " Highlight current paragraph (works well with goyo)
  use { 'junegunn/limelight.vim', cmd = 'Limelight' }

  -- growing collection of settings, commands and mappings put together to make
  -- working with the location list/window and the quickfix list/window smoother
  use { 'romainl/vim-qf' }

  -- Simple plugin for placing signs in buffer's gutter next to lines that appear in the QuickFix results.
  use { 'matthias-margush/qfx.vim' }

  -- Simple plugin for placing signs in buffer's gutter next to lines that appear in the QuickFix results.
  -- https://gitlab.com/hauleth/qfx.vim
  use 'https://gitlab.com/hauleth/qfx.vim.git'

  -- navigate to directory of current file using `-`
  use { 'tpope/vim-vinegar' }

  -- ruby gem info directly in a Gemfile
  use { 'alexbel/vim-rubygems', ft = { 'ruby' } }

  -- support for Gleam language
  use { 'gleam-lang/gleam.vim' }

  --  Erlang: {{{
  -- erlang syntax
  use { 'vim-erlang/vim-erlang-runtime' }
  --  }}}

  -- Elixir: {{{
  -- Elixir support
  use { 'elixir-lang/vim-elixir' }

  -- elixir text objects
  use {
    'duff/vim-textobj-elixir',
    requires = { 'kana/vim-textobj-user' },
  }

  -- temporarily use this plugin to format elixir - until ALE starts supporting
  -- umbrella apps and respect nested .formatter.exs files (see
  -- https://github.com/dense-analysis/ale/pull/3106)
  use 'mhinz/vim-mix-format'

  -- pulls info on hex packages (requires mattn/webapi-vim)
  use { 'lucidstack/hex.vim', ft = { 'elixir' } }
  -- }}}

  -- " add text object for HTML attributes - allows dax cix etc
  use {
    'whatyouhide/vim-textobj-xmlattr',
    requires = { 'kana/vim-textobj-user' },
  }

  -- graphql support
  use { 'jparise/vim-graphql' }

  -- Vim sugar for the UNIX shell commands that need it the most.
  use { 'tpope/vim-eunuch' }

  -- allow (non-native) plugins to use the . command
  use { 'tpope/vim-repeat' }

  -- Surround text with closures
  use { 'tpope/vim-surround' }

  -- vim projectionist allows creating :Esomething custom shortcuts (required by vim rake)
  use { 'tpope/vim-projectionist' }

  -- vim unimpaired fixes daily annoyences
  use { 'tpope/vim-unimpaired' }

  -- abolish.vim: easily search for, substitute, and abbreviate multiple variants
  -- of a word
  use { 'tpope/vim-abolish' }

  -- Support emacs keybindings in insert mode
  use { 'tpope/vim-rsi' }

  -- save vim sessions
  use { 'tpope/vim-obsession' }

  -- Comment out code easily
  use { 'tpope/vim-commentary' }
  -- }}}

  -- HTML: {{{
  -- RagTag: Auto-close html tags + mappings for template scripting languages
  use { 'tpope/vim-ragtag' }

  -- automatic bulleted lists
  use { 'dkarter/bullets.vim' }

  -- snip helpers - assorted functions for snippets
  use { 'dkarter/sniphelpers.vim' }

  -- " replacement for matchit
  use { 'andymass/vim-matchup' }

  --  add `end` automatically when creating a closure in many languages
  use { 'tpope/vim-endwise' }

  -- window animations
  use { 'camspiers/animate.vim' }

  --  auto-generate ctags on save
  use { 'jsfaint/gen_tags.vim' }

  -- " show trailing white spaces and allow deleting them
  use 'ntpeters/vim-better-whitespace'

  --  Multiple cursor emulation (a la Sublime Text) using ctrl-n
  use { 'mg979/vim-visual-multi', branch = 'master' }

  -- " Convert code to multiline
  use { 'AndrewRadev/splitjoin.vim' }

  -- " Toggle between different language verbs or syntax styles
  use { 'AndrewRadev/switch.vim' }

  -- The ultimate undo history visualizer for VIM
  use { 'mbbill/undotree' }

  -- Rust support
  use { 'rust-lang/rust.vim', ft = { 'rust' } }

  --  Indent lines (visual indication)
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('plugins.indent_blankline').setup()
    end,
  }

  -- Golang support
  use { 'fatih/vim-go', ft = { 'go' } }

  -- resize windows in vim naturally
  use { 'simeji/winresizer', cmd = 'WinResizerStartResize' }

  -- " staticly check code and highlight errors (async syntastic replacement)
  use 'dense-analysis/ale'

  -- smooth scrolling in neovim
  use {
    'declancm/cinnamon.nvim',
    config = function()
      require('cinnamon').setup()
    end,
  }

  -- fuzzy finder (still used by a lot of small workflows I built FzfRg,
  -- GConflict etc)
  use { 'junegunn/fzf', run = 'cd ~/.fzf && ./install --all' }
  use 'junegunn/fzf.vim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-packer.nvim',
      'nvim-telescope/telescope-github.nvim',
      'olacin/telescope-cc.nvim',
    },
    config = function()
      require('plugins.telescope').setup()
    end,
  }

  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- " highlights all search results and allows tabbing between them
  use { 'haya14busa/incsearch.vim' }

  -- " RipGrep - grep is dead. All hail the new king RipGrep.
  use { 'jremmen/vim-ripgrep' }

  -- " same as tabular but by Junegunn and way easier
  use { 'junegunn/vim-easy-align' }

  -- " move function arguments
  use { 'AndrewRadev/sideways.vim' }

  -- manage github gists
  use { 'mattn/gist-vim', cmd = 'Gist', requires = { 'mattn/webapi-vim' } }

  -- PostgreSQL highlighting
  use 'exu/pgsql.vim'

  --- TMUX ---

  -- " .tmux.conf syntax highlighting
  use { 'ericpruitt/tmux.vim', ft = 'tmux' }

  -- " tmux config file stuff
  use { 'tmux-plugins/vim-tmux' }

  -- " vim slime for tmux integration (C-c, C-c to send selction to tmux)
  use { 'jpalardy/vim-slime' }

  -- " seamless tmux/vim pane navigation
  use { 'christoomey/vim-tmux-navigator' }

  -- " yet another tmux plugin
  use { 'benmills/vimux' }

  -- " autocomplete using text from tmux
  use { 'wellle/tmux-complete.vim' }
end)
