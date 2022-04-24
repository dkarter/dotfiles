local present, treesitter = pcall(require, 'nvim-treesitter.configs')

if not present then
  return
end

local default = {
  -- one of "all", or a list of languages
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
}

local M = {}

M.setup = function()
  treesitter.setup(default)
end

return M
