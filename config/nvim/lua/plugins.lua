local present, packer = pcall(require, "packer_init")

if not present then
  return false
end

return packer.startup(function(use)
  -- Speed up loading Lua modules in Neovim to improve startup time.
  use({ "lewis6991/impatient.nvim" })

  -- Packer can manage itself
  use({ "wbthomason/packer.nvim", event = "VimEnter" })

  -- color schemes
  ----------------

  use({
    "marko-cerovac/material.nvim",
    config = function()
      vim.g.material_style = "palenight"

      require("material").setup({
        contrast = {
          sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
          floating_windows = false, -- Enable contrast for floating windows
          line_numbers = false, -- Enable contrast background for line numbers
          sign_column = false, -- Enable contrast background for the sign column
          cursor_line = false, -- Enable darker background for the cursor line
          non_current_windows = false, -- Enable darker background for non-current windows
          popup_menu = false, -- Enable lighter background for the popup menu
        },

        italics = {
          comments = true, -- Enable italic comments
          keywords = false, -- Enable italic keywords
          functions = false, -- Enable italic functions
          strings = false, -- Enable italic strings
          variables = false, -- Enable italic variables
        },

        contrast_filetypes = { -- Specify which filetypes get the contrasted (darker) background
          "terminal", -- Darker terminal background
          "packer", -- Darker packer background
          "qf", -- Darker qf list background
        },

        disable = {
          borders = false, -- Disable borders between verticaly split windows
          background = false, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
          term_colors = false, -- Prevent the theme from setting terminal colors
          eob_lines = false, -- Hide the end-of-buffer lines
        },

        high_visibility = {
          lighter = false, -- Enable higher contrast text for lighter style
          darker = false, -- Enable higher contrast text for darker style
        },
      })
      -- set colorscheme
      vim.cmd([[colorscheme material]])
    end,
  })

  -- " iA Writer Scheme
  use({ "reedes/vim-colors-pencil", cmd = "Goyo" })
  ------------------------------------

  -- vim one (previous colorscheme, might still be useful)
  use({ "rakr/vim-one" })

  -- status line
  use({
    "feline-nvim/feline.nvim",
    requires = { "lewis6991/gitsigns.nvim", "kyazdani42/nvim-web-devicons" },
    after = "nvim-web-devicons",
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

  -- temporarily use this plugin to format elixir - until ALE starts supporting
  -- umbrella apps and respect nested .formatter.exs files (see
  -- https://github.com/dense-analysis/ale/pull/3106)
  use("mhinz/vim-mix-format")

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

  -- window animations
  use({ "camspiers/animate.vim" })

  --  auto-generate ctags on save
  use({ "jsfaint/gen_tags.vim" })

  -- " show trailing white spaces and allow deleting them
  use("ntpeters/vim-better-whitespace")

  --  Multiple cursor emulation (a la Sublime Text) using ctrl-n
  use({ "mg979/vim-visual-multi", branch = "master" })

  -- " Convert code to multiline
  use({ "AndrewRadev/splitjoin.vim" })

  -- " Toggle between different language verbs or syntax styles
  use({ "AndrewRadev/switch.vim" })

  -- The ultimate undo history visualizer for VIM
  use({ "mbbill/undotree" })

  -- Rust support
  use({ "rust-lang/rust.vim", ft = { "rust" } })

  --  Indent lines (visual indication)
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins.indent_blankline").setup()
    end,
  })

  -- Golang support
  use({ "fatih/vim-go", ft = { "go" } })

  -- resize windows in vim naturally
  use({ "simeji/winresizer", cmd = "WinResizerStartResize" })

  -- " staticly check code and highlight errors (async syntastic replacement)
  use("dense-analysis/ale")

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

  -- fuzzy finder (still used by a lot of small workflows I built FzfRg,
  -- GConflict etc)
  use({ "junegunn/fzf", run = "cd ~/.fzf && ./install --all" })
  use("junegunn/fzf.vim")

  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-packer.nvim",
      "nvim-telescope/telescope-github.nvim",
    },
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

  -- manage github gists
  use({ "mattn/gist-vim", cmd = "Gist", requires = { "mattn/webapi-vim" } })

  -- PostgreSQL highlighting
  use("exu/pgsql.vim")

  --- TMUX ---

  -- " .tmux.conf syntax highlighting
  use({ "ericpruitt/tmux.vim", ft = "tmux" })

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
