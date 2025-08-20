-- installs/updates LSPs, linters and DAPs
---@type LazySpec
return {
  'mason-org/mason.nvim',
  -- temporarily lock to v1 to avoid dealing with breaking changes - after v2
  -- stabilizes this can be updated to 2.0.0 or removed
  build = ':MasonUpdate',
  cmd = { 'Mason', 'MasonUpdate', 'MasonUpdateAll' },
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    -- handles connection of LSP Configs and Mason
    'mason-org/mason-lspconfig.nvim',

    -- Collection of configurations for the built-in LSP client
    'neovim/nvim-lspconfig',

    -- required for setting up capabilities for cmp
    'hrsh7th/cmp-nvim-lsp',

    -- required for jsonls and yamlls
    { 'b0o/schemastore.nvim', lazy = true },
  },
  config = function()
    require('core.lsp').setup()
    local mason = require 'mason'
    local mason_lspconfig = require 'mason-lspconfig'

    local package_list = {
      -- Null LS
      'actionlint',
      'ansible-lint',
      -- js/json/yaml/ts/etc formatter
      'biome',
      -- python formatter
      'black',
      'prettierd',
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

    ---@type MasonSettings
    mason.setup {}

    -- Auto install all packages in the package_list
    local mr = require 'mason-registry'
    local function ensure_installed()
      for _, tool in ipairs(package_list) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end

    if mr.refresh then
      mr.refresh(ensure_installed)
    else
      ensure_installed()
    end

    mason_lspconfig.setup {}
  end,
}
