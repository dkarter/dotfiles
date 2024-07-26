local utils = require 'core.utils'

local lspconfig_present, lspconfig = pcall(require, 'lspconfig')
local mason_lspconfig_present, mason_lspconfig = pcall(require, 'mason-lspconfig')
local mason_present, mason = pcall(require, 'mason')

local deps = {
  mason_present,
  mason_lspconfig_present,
  lspconfig_present,
}

if utils.contains(deps, false) then
  vim.notify 'Failed to load dependencies in plugins/mason.lua'
  return
end

local M = {}

-- Sets up Mason and Mason LSP Config
M.setup = function()
  local root_pattern = lspconfig.util.root_pattern

  local package_list = {
    -- Null LS
    'actionlint',
    'ansible-lint',
    -- python formatter
    'black',
    'codespell',
    'prettierd',
    'rubocop',
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
    -- XML
    'lemminx',
    'lua-language-server',
    -- Markdown
    'prosemd-lsp',
    'python-lsp-server',
    'rust-analyzer',
    -- Ruby
    'rubocop',
    'ruby-lsp',
    'rubyfmt',
    'sqlls',
    'tailwindcss-language-server',
    'taplo',
    'terraform-ls',
    'typescript-language-server',
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

  ---@diagnostic disable-next-line: redundant-parameter
  mason.setup {}

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
  mason_lspconfig.setup_handlers {
    function(server_name)
      lspconfig[server_name].setup {}
    end,

    ['tailwindcss'] = function()
      lspconfig.tailwindcss.setup {
        root_dir = root_pattern(
          'assets/tailwind.config.js',
          'tailwind.config.js',
          'tailwind.config.ts',
          'postcss.config.js',
          'postcss.config.ts',
          'package.json',
          'node_modules'
        ),
        init_options = {
          userLanguages = {
            elixir = 'phoenix-heex',
            eruby = 'erb',
            heex = 'phoenix-heex',
            svelte = 'html',
          },
        },
        handlers = {
          ['tailwindcss/getConfiguration'] = function(_, _, params, _, bufnr, _)
            vim.lsp.buf_notify(bufnr, 'tailwindcss/getConfigurationResponse', { _id = params._id })
          end,
        },
        settings = {
          includeLanguages = {
            typescript = 'javascript',
            typescriptreact = 'javascript',
            ['html-eex'] = 'html',
            ['phoenix-heex'] = 'html',
            heex = 'html',
            eelixir = 'html',
            elm = 'html',
            erb = 'html',
            svelte = 'html',
          },
          tailwindCSS = {
            lint = {
              cssConflict = 'warning',
              invalidApply = 'error',
              invalidConfigPath = 'error',
              invalidScreen = 'error',
              invalidTailwindDirective = 'error',
              invalidVariant = 'error',
              recommendedVariantOrder = 'warning',
            },
            experimental = {
              classRegex = {
                [[class= "([^"]*)]],
                [[class: "([^"]*)]],
                '~H""".*class="([^"]*)".*"""',
              },
            },
            validate = true,
          },
        },
        filetypes = {
          'css',
          'scss',
          'sass',
          'html',
          'heex',
          'elixir',
          'eruby',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
          'svelte',
        },
      }
    end,

    -- JSON
    ['jsonls'] = function()
      local overrides = require 'plugins.lsp.jsonls'
      lspconfig.jsonls.setup(overrides)
    end,

    -- YAML
    ['yamlls'] = function()
      local overrides = require('plugins.lsp.yamlls').setup()
      lspconfig.yamlls.setup(overrides)
    end,

    -- Lua
    ['lua_ls'] = function()
      -- Make runtime files discoverable to the lua server
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, 'lua/?.lua')
      table.insert(runtime_path, 'lua/?/init.lua')

      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Setup your lua path
              path = runtime_path,
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
              unusedLocalExclude = { '_*' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file('', true),
              -- Stop prompting about 'luassert'. See https://github.com/neovim/nvim-lspconfig/issues/1700
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      }
    end,
  }
end

return M
