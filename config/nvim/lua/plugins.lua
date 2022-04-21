local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  _G.packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -- color schemes
  ----------------
  -- vim one
  use({
    "rakr/vim-one",
    config = function()
      -- set colorscheme
      vim.cmd("colorscheme one")
    end,
  })

  -- " iA Writer Scheme
  use({ "reedes/vim-colors-pencil" })
  ------------------------------------

  -- status line
  use({
    "feline-nvim/feline.nvim",
    requires = { "lewis6991/gitsigns.nvim", "kyazdani42/nvim-web-devicons" },
    config = function()
      require("feline").setup()
    end,
  })

  -- " Visual git gutter (also used by feline)
  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.gitsigns").setup()
    end,
  })

  -- delete unused buffers
  use({ "schickling/vim-bufonly" })

  -- nginx syntax support
  use({ "chr4/nginx.vim" })

  -- run tests at the speed of thought
  use({ "janko-m/vim-test" })

  -- Highlight Yanked String
  use({ "machakann/vim-highlightedyank" })

  -- browse commit history for file
  use({
    "junegunn/gv.vim",
    requires = { "tpope/vim-fugitive" },
  })

  -- git integration
  use({ "tpope/vim-fugitive" })

  -- github support for fugitive
  use({
    "tpope/vim-rhubarb",
    requires = { "tpope/vim-fugitive" },
  })
  --  Better syntax highlighting
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("plugins.treesitter").setup()
    end,
  })

  -- pretty buffers
  use({
    "akinsho/bufferline.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("plugins.bufferline").setup()
    end,
  })

  -- file tree
  use({
    "kyazdani42/nvim-tree.lua",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("plugins.nvimtree").setup()
    end,
  })

  -- " Distraction free writing in vim
  use({ "junegunn/goyo.vim", cmd = "Goyo" })

  -- " Highlight current paragraph (works well with goyo)
  use({ "junegunn/limelight.vim", cmd = "Limelight" })

  -- growing collection of settings, commands and mappings put together to make
  -- working with the location list/window and the quickfix list/window smoother
  use({ "romainl/vim-qf" })

  -- Simple plugin for placing signs in buffer's gutter next to lines that appear in the QuickFix results.
  use({ "matthias-margush/qfx.vim" })

  -- Simple plugin for placing signs in buffer's gutter next to lines that appear in the QuickFix results.
  -- https://gitlab.com/hauleth/qfx.vim
  use("https://gitlab.com/hauleth/qfx.vim.git")

  -- navigate to directory of current file using `-`
  use({ "tpope/vim-vinegar" })

  -- ruby gem info directly in a Gemfile
  use({ "alexbel/vim-rubygems", ft = { "ruby" } })

  -- support for Gleam language
  use({ "gleam-lang/gleam.vim" })

  --  Erlang: {{{
  -- erlang syntax
  use({ "vim-erlang/vim-erlang-runtime" })
  --  }}}

  -- Elixir: {{{
  -- Elixir support
  use({ "elixir-lang/vim-elixir" })

  -- elixir text objects
  use({
    "duff/vim-textobj-elixir",
    requires = { "kana/vim-textobj-user" },
  })

  -- pulls info on hex packages (requires mattn/webapi-vim)
  use({ "lucidstack/hex.vim", ft = { "elixir" } })
  -- }}}

  -- " add text object for HTML attributes - allows dax cix etc
  use({
    "whatyouhide/vim-textobj-xmlattr",
    requires = { "kana/vim-textobj-user" },
  })

  -- graphql support
  use({ "jparise/vim-graphql" })

  -- Vim sugar for the UNIX shell commands that need it the most.
  use({ "tpope/vim-eunuch" })

  -- allow (non-native) plugins to use the . command
  use({ "tpope/vim-repeat" })

  -- Surround text with closures
  use({ "tpope/vim-surround" })

  -- vim projectionist allows creating :Esomething custom shortcuts (required by vim rake)
  use({ "tpope/vim-projectionist" })

  -- vim unimpaired fixes daily annoyences
  use({ "tpope/vim-unimpaired" })

  -- abolish.vim: easily search for, substitute, and abbreviate multiple variants
  -- of a word
  use({ "tpope/vim-abolish" })

  -- Support emacs keybindings in insert mode
  use({ "tpope/vim-rsi" })

  -- save vim sessions
  use({ "tpope/vim-obsession" })

  -- Comment out code easily
  use({ "tpope/vim-commentary" })
  -- }}}

  -- HTML: {{{
  -- RagTag: Auto-close html tags + mappings for template scripting languages
  use({ "tpope/vim-ragtag" })

  -- automatic bulleted lists
  use({ "dkarter/bullets.vim" })

  -- snip helpers - assorted functions for snippets
  use({ "dkarter/sniphelpers.vim" })

  -- " replacement for matchit
  use({ "andymass/vim-matchup" })

  --  add `end` automatically when creating a closure in many languages
  use({ "tpope/vim-endwise" })

  --  auto-generate ctags on save
  use({ "jsfaint/gen_tags.vim" })

  --  Multiple cursor emulation (a la Sublime Text) using ctrl-n
  use({ "mg979/vim-visual-multi", branch = "master" })

  -- " Convert code to multiline
  use({ "AndrewRadev/splitjoin.vim" })

  -- " Toggle between different language verbs or syntax styles
  use({ "AndrewRadev/switch.vim" })

  -- The ultimate undo history visualizer for VIM
  use({ "mbbill/undotree" })

  --  Indent lines (visual indication)
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins.indent_blankline").setup()
    end,
  })

  -- smooth scrolling in neovim
  use({
    "declancm/cinnamon.nvim",
    config = function()
      require("cinnamon").setup()
    end,
  })

  vim.g.coc_global_extensions = {
    "coc-css",
    "coc-dictionary",
    "coc-eslint",
    "coc-github",
    "coc-gitignore",
    "coc-gocode",
    "coc-highlight",
    "coc-html",
    "coc-json",
    "coc-neosnippet",
    "coc-omni",
    "coc-prettier",
    "coc-rls",
    "coc-snippets",
    "coc-solargraph",
    "coc-svg",
    "coc-syntax",
    "coc-tsserver",
    "coc-ultisnips",
    "coc-vimlsp",
    "coc-yaml",
    "coc-yank",
    "coc-react-refactor",
    "coc-lua",
  }

  use({ "neoclide/coc.nvim", branch = "release" })
  use({ "antoinemadec/coc-fzf", requires = { "neoclide/coc.nvim" } })

  use({
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.telescope").setup()
    end,
  })

  -- " highlights all search results and allows tabbing between them
  use({ "haya14busa/incsearch.vim" })

  -- " RipGrep - grep is dead. All hail the new king RipGrep.
  use({ "jremmen/vim-ripgrep" })

  -- " same as tabular but by Junegunn and way easier
  use({ "junegunn/vim-easy-align" })

  -- " move function arguments
  use({ "AndrewRadev/sideways.vim" })

  --- TMUX ---

  -- " .tmux.conf syntax highlighting
  use({ "keith/tmux.vim", ft = "tmux" })

  -- " tmux config file stuff
  use({ "tmux-plugins/vim-tmux" })

  -- " vim slime for tmux integration (C-c, C-c to send selction to tmux)
  use({ "jpalardy/vim-slime" })

  -- " seamless tmux/vim pane navigation
  use({ "christoomey/vim-tmux-navigator" })

  -- " yet another tmux plugin
  use({ "benmills/vimux" })

  -- " autocomplete using text from tmux
  use({ "wellle/tmux-complete.vim" })
  ------------

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if _G.packer_bootstrap then
    require("packer").sync()
  end
end)
