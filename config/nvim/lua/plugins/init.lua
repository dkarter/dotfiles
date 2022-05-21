local present, packer = pcall(require, 'plugins.packer_init')

if not present then
  return false
end

return packer.startup(function(use)
  -- Packer can manage itself
  use {
    'wbthomason/packer.nvim',
    config = function()
      require('core.mappings').packer_mappings()
    end,
  }

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
      -- tmux pane completion
      'andersevenrud/cmp-tmux',
      -- snippets!
      'rafamadriz/friendly-snippets',
    },
    config = function()
      require('plugins.cmp').setup()
    end,
  }

  -- installs and sets up lsps for you
  use {
    'junnplus/nvim-lsp-setup',
    requires = {
      -- just installs/updates LSPs
      'williamboman/nvim-lsp-installer',

      -- LSP driven completions
      'hrsh7th/cmp-nvim-lsp',

      -- Collection of configurations for the built-in LSP client
      'neovim/nvim-lspconfig',

      -- elixir commands from elixirls
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
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('plugins.lualine').setup()
    end,
  }

  use {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require('octo').setup()
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

  use { 'zdharma-continuum/zinit-vim-syntax', ft = { 'zsh' } }

  -- delete unused buffers
  use { 'schickling/vim-bufonly', cmd = 'BO' }

  -- nginx syntax support
  use { 'chr4/nginx.vim' }

  -- run tests at the speed of thought
  use {
    'janko-m/vim-test',
    requires = { 'benmills/vimux' },
    config = function()
      vim.g['test#strategy'] = 'vimux'
      vim.cmd [[let test#javascript#jest#file_pattern = '\v(__tests__/.*|(spec|test|__tests__))\.(js|jsx|coffee|ts|tsx)$']]
      require('core.mappings').vim_test_mappings()
    end,
  }

  -- Highlight Yanked String
  use { 'machakann/vim-highlightedyank' }

  -- browse commit history for file
  use {
    'junegunn/gv.vim',
    requires = { 'tpope/vim-fugitive' },
    config = function()
      require('core.mappings').fugitive_mappings()
    end,
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

  use {
    'lewis6991/spellsitter.nvim',
    requires = {

      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('spellsitter').setup()
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

  -- " Highlight current paragraph (works well with goyo)
  use {
    'junegunn/limelight.vim',
    cmd = 'Limelight',
    setup = function()
      vim.g.limelight_paragraph_span = 1
      vim.g.limelight_priority = -1
    end,
  }

  -- growing collection of settings, commands and require('core.mappings') put together to make
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
    'kevinkoltz/vim-textobj-elixir',
    requires = { 'kana/vim-textobj-user' },
    ft = { 'elixir' },
  }

  -- temporarily use this plugin to format elixir - until ALE starts supporting
  -- umbrella apps and respect nested .formatter.exs files (see
  -- https://github.com/dense-analysis/ale/pull/3106)
  use {
    'mhinz/vim-mix-format',
    setup = function()
      vim.g.mix_format_on_save = 1
    end,
  }

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
  use {
    'tpope/vim-projectionist',
    setup = function()
      require 'plugins.projectionist'
    end,
  }

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
  use {
    'dkarter/bullets.vim',
    setup = function()
      vim.g.bullets_enabled_file_types = {
        'markdown',
        'text',
        'gitcommit',
        'scratch',
      }
    end,
  }

  -- snip helpers - assorted functions for snippets
  use { 'dkarter/sniphelpers.vim' }

  -- " replacement for matchit
  use {
    'andymass/vim-matchup',
    setup = function()
      vim.g.matchup_matchparen_deferred = 1
    end,
  }

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
  use {
    'AndrewRadev/splitjoin.vim',
    setup = function()
      vim.g.splitjoin_align = 1
      vim.g.splitjoin_trailing_comma = 1
      vim.g.splitjoin_ruby_curly_braces = 0
      vim.g.splitjoin_ruby_hanging_args = 0
    end,
  }

  -- " Toggle between different language verbs or syntax styles
  use {
    'AndrewRadev/switch.vim',
    setup = function()
      vim.g.switch_custom_definitions = {
        { 'up', 'down', 'change' },
        { 'add', 'drop', 'remove' },
        { 'create', 'drop' },
        { 'row', 'column' },
        { 'first', 'second', 'third', 'fourth', 'fifth' },
        { 'yes', 'no' },
      }
    end,
  }

  -- The ultimate undo history visualizer for VIM
  use {
    'mbbill/undotree',
    config = function()
      require('core.mappings').undotree_mappings()
    end,
  }

  -- Rust support
  use { 'rust-lang/rust.vim', ft = { 'rust' } }

  --  Indent lines (visual indication)
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('plugins.indent_blankline').setup()
    end,
  }

  -- resize windows in vim naturally
  use {
    'simeji/winresizer',
    cmd = 'WinResizerStartResize',
    config = function()
      require('core.mappings').winresizer_mappings()
    end,
  }

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

  -- use Neovim inside Firefox
  use {
    'glacambre/firenvim',
    run = function()
      vim.fn['firenvim#install'](0)
    end,
  }

  -- RipGrep - grep is dead. All hail the new king RipGrep.
  use {
    'jremmen/vim-ripgrep',
    config = function()
      require('core.mappings').ripgrep_mappings()
    end,
  }

  -- " same as tabular but by Junegunn and way easier
  use {
    'junegunn/vim-easy-align',
    config = function()
      require('core.mappings').easy_align_mappings()
    end,
  }

  -- manage github gists
  use { 'mattn/gist-vim', cmd = 'Gist', requires = { 'mattn/webapi-vim' } }

  -- PostgreSQL highlighting
  use 'exu/pgsql.vim'

  -- Helm Chart syntax
  use 'towolf/vim-helm'

  --- TMUX ---

  -- " tmux config file stuff
  use { 'tmux-plugins/vim-tmux', ft = 'tmux' }

  -- " seamless tmux/vim pane navigation
  use { 'christoomey/vim-tmux-navigator' }

  -- Resize tmux panes and Vim windows with ease.
  use 'RyanMillerC/better-vim-tmux-resizer'

  -- support editorconfig files
  use { 'gpanders/editorconfig.nvim' }

  -- notifications
  use {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require 'notify'
      notify.setup {
        background_colour = '#000',
      }
      vim.notify = notify
    end,
  }
end)
