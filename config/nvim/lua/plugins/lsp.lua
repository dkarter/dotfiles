local utils = require 'core.utils'

local mason_present, mason = pcall(require, 'mason')
local mason_lspconfig_present, mason_lspconfig = pcall(require, 'mason-lspconfig')
local lspconfig_present, lspconfig = pcall(require, 'lspconfig')

if utils.contains({ mason_present, mason_lspconfig_present, lspconfig_present }, nil) then
  vim.notify 'Failed to load dependencies in plugins/lsp.lua'
  return
end

local M = {}

local appearance_mods = function()
  -- set a border around lsp hover popover and signature help
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
  })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
  })
end

M.setup = function()
  -- Make runtime files discoverable to the lua server
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o> (not sure this is necessary with
    -- vmp plugin)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    require('core.mappings').lsp_mappings(bufnr)
  end

  -- set up global mappings for diagnostics
  require('core.mappings').lsp_diagnostic_mappings()

  mason.setup()
  mason_lspconfig.setup {
    ensure_installed = {
      'ansible-language-server',
      'arduino-language-server',
      'bash-language-server',
      'clangd',
      'cmake-language-server',
      'css-lsp',
      'dockerfile-language-server',
      'elixirls',
      'elm-language-server',
      'emmet-ls',
      'eslint-lsp',
      'erlang-ls',
      'gopls',
      'html-lsp',
      'json-lsp',
      'prosemd-lsp',
      'rust-analyzer',
      'solargraph',
      'sqlls',
      'lua-language-server',
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
      lspconfig[server_name].setup { on_attach = on_attach }
    end,

    -- JSON
    jsonls = function()
      local overrides = require 'plugins.lsp.jsonls'
      lspconfig.jsonls.setup(overrides)
    end,

    -- YAML
    yamlls = function()
      local overrides = require('plugins.lsp.yamlls').setup(on_attach)
      lspconfig.yamlls.setup(overrides)
    end,

    -- Lua
    sumneko_lua = function()
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
    elixirls = function()
      lspconfig.elixirls.setup {
        on_attach = function(client, bufnr)
          -- regular on_attach for lsp
          on_attach(client, bufnr)
          require('elixir').on_attach(client, bufnr)
        end,
      }
    end,
  }

  appearance_mods()
end

return M
