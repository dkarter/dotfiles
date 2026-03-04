-- installs/updates LSPs, linters and DAPs
---@type LazySpec
return {
  'mason-org/mason.nvim',
  -- temporarily lock to v1 to avoid dealing with breaking changes - after v2
  -- stabilizes this can be updated to 2.0.0 or removed
  build = ':MasonUpdate',
  cmd = { 'Mason', 'MasonUpdate', 'MasonUpdateAll' },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local mason = require 'mason'

    local package_list = {
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
      'elixir-ls',
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
  end,
}
