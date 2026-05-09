local packages = {
  -- Null LS
  'actionlint',
  'ansible-lint',
  -- js/json/yaml/ts/etc formatter
  'biome',
  -- python linting/formatting
  'black',
  'prettierd',
  'shfmt',
  'stylua',
  'yamllint',

  -- LSPs
  -- 'expert',
  'ansible-language-server',
  'arduino-language-server',
  'bash-language-server',
  'clangd',
  'clang-format',
  'cmake-language-server',
  'commitlint',
  'css-lsp',
  'dockerfile-language-server',
  -- super fast formatter for multiple languages
  'dprint',
  'elm-language-server',
  'eslint-lsp',
  'gopls',
  'go-debug-adapter',
  'goimports',
  'golangci-lint',
  'golangci-lint-langserver',
  'gomodifytags',
  'helm-ls',
  'html-lsp',
  'json-lsp',
  -- XML
  'lemminx',
  'lua-language-server',
  'powershell-editor-services',
  'python-lsp-server',
  'rust-analyzer',
  -- Ruby
  'rubocop',
  'ruby-lsp',
  'rubyfmt',
  -- python linting/formatting
  'ruff',
  'shellcheck',
  'sqlls',
  'tailwindcss-language-server',
  'taplo',
  'terraform-ls',
  'typescript-language-server',
  'typos',
  'typos-lsp',
  'vim-language-server',
  'yaml-language-server',
  'zls',

  -- DAP
  'bash-debug-adapter',
  'delve',
  'js-debug-adapter',

  -- Other utils
  'tree-sitter-cli',
}

local uv = vim.uv or vim.loop
local uname = uv.os_uname()

if uname.sysname == 'Linux' and (uname.machine == 'aarch64' or uname.machine == 'arm64') then
  local unsupported = {
    clangd = true,
    typos = true,
  }
  local supported = {}

  for _, package in ipairs(packages) do
    if not unsupported[package] then
      table.insert(supported, package)
    end
  end

  return supported
end

return packages
