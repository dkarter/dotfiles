local present, treesitter = pcall(require, 'nvim-treesitter.configs')

if not present then
  return
end

local default = {
  -- see full list here:
  -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
  ensure_installed = {
    'bash',
    'c',
    'cmake',
    'comment',
    'cpp',
    'css',
    'dockerfile',
    'eex',
    -- Elixir treesitter is very slow
    -- "elixir",
    'elm',
    'erlang',
    'gleam',
    'go',
    'graphql',
    'haskell',
    'heex',
    'help',
    'hjson',
    'html',
    'http',
    'java',
    'javascript',
    'jsdoc',
    'json',
    'json5',
    'jsonc',
    'llvm',
    'lua',
    'make',
    'markdown',
    'python',
    'regex',
    'ruby',
    'rust',
    'scss',
    'surface',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'yaml',
    'zig',
  },
  highlight = { enable = true },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>pn'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>pp'] = '@parameter.inner',
      },
    },
    move = {
      enable = true,
      -- whether to set jumps in the jumplist
      set_jumps = true,
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
}

local M = {}

M.setup = function()
  treesitter.setup(default)
end

return M
