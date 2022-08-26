local utils = require 'core.utils'

local elixir_present, elixir = pcall(require, 'elixir.language_server')
local lspconfig_present, lspconfig = pcall(require, 'lspconfig')
local mason_lspconfig_present, mason_lspconfig = pcall(require, 'mason-lspconfig')
local mason_present, mason = pcall(require, 'mason')

local deps = {
  elixir_present,
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
  mason_lspconfig.setup {}
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
              unusedLocalExclude = { '_*' },
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
        settings = elixir.settings {},
        on_attach = elixir.on_attach,
      }
    end,
  }
end

return M
