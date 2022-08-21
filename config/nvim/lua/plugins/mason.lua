local utils = require 'core.utils'

local mason_present, mason = pcall(require, 'mason')
local mason_lspconfig_present, mason_lspconfig = pcall(require, 'mason-lspconfig')
local lspconfig_present, lspconfig = pcall(require, 'lspconfig')

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
  mason.setup {}
  mason_lspconfig.setup {
    ensure_installed = {
      'ansible-language-server',
      'arduino-language-server',
      'bash-language-server',
      'clangd',
      'cmake-language-server',
      'css-lsp',
      'dockerfile-language-server',
      'elixir-ls',
      'elm-language-server',
      'emmet-ls',
      'erlang-ls',
      'eslint-lsp',
      'gopls',
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

  mason_lspconfig.setup_handlers {
    function(server_name)
      lspconfig[server_name].setup {}
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
    ['sumneko_lua'] = function()
      -- Make runtime files discoverable to the lua server
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, 'lua/?.lua')
      table.insert(runtime_path, 'lua/?/init.lua')

      lspconfig.sumneko_lua.setup {
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
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file('', true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      }
    end,

    -- Elixir
    ['elixirls'] = function()
      lspconfig.elixirls.setup {
        settings = require('elixir').settings {},
        on_attach = function(client, bufnr)
          --[[ -- regular on_attach for lsp ]]
          --[[ on_attach(client, bufnr) ]]
          -- use on_attach from elixir.nvim plugin
          require('elixir').on_attach(client, bufnr)
        end,
        elixirLS = {
          dialyzerEnabled = true,
          fetchDeps = false,
        },
      }
    end,
  }
end

return M
