return {
  start_delay = 3000,
  -- a list of all tools you want to ensure are installed upon
  -- start; they should be the names Mason uses for each tool
  ensure_installed = {
    -- Null LS
    'actionlint',
    'codespell',
    'eslint_d',
    'prettierd',
    'rubocop',
    'shellcheck',
    'shfmt',
    'stylua',
    'yamllint',

    -- LSPs
    -- NOTE: you do not need to add `elixir-ls` here.. it is now handled by
    -- the elixir plugin. This is because Mason does not support downloading
    -- and building LSPs using the project runtime. For more info see:
    -- https://github.com/elixir-lsp/elixir-ls/issues/193
    -- https://dragoshmocrii.com/fix-vscode-elixirls-intellisense-for-code-imported-with-use/
    'ansible-language-server',
    'arduino-language-server',
    'bash-language-server',
    'clangd',
    'cmake-language-server',
    'css-lsp',
    'dockerfile-language-server',
    'elm-language-server',
    'erlang-ls',
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
    'lua-language-server',
    'prosemd-lsp',
    'rust-analyzer',
    'solargraph',
    'sqlls',
    'tailwindcss-language-server',
    'taplo',
    'terraform-ls',
    'typescript-language-server',
    'vim-language-server',
    'yaml-language-server',
    'zls',
  },
}
