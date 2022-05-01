local present, lspsetup = pcall(require, 'nvim-lsp-setup')

if not present then
  return
end

local M = {}

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

  lspsetup.setup {
    -- I'll use my own mappings
    default_mappings = false,

    -- Global on_attach
    on_attach = on_attach,

    -- Global capabilities (cmp_nvim_lsp will automatically advertise
    -- capabilities) as per https://github.com/junnplus/nvim-lsp-setup#cmp-nvim-lsp
    -- capabilities = not necessary...

    -- Configuration of LSP servers
    servers = {
      -- Install LSP servers automatically
      -- LSP server configuration please see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

      -- zig
      zls = {},

      -- Arduino
      arduino_language_server = {},

      -- cmake
      cmake = {},

      -- Elm
      elmls = {},

      -- Markdown
      prosemd_lsp = {},

      -- SQL
      sqlls = {},

      -- Erlang
      erlangls = {},

      -- HTML snippets
      emmet_ls = {},

      -- TOML
      taplo = {},

      -- C, CPP
      clangd = {},

      -- C, CPP, Arduino
      ccls = {},

      -- Rust
      rust_analyzer = {},

      -- TypeScript and JavaScript
      tsserver = {},

      -- Ruby
      solargraph = {},

      -- Dockerfile
      dockerls = {},

      -- Terraform
      terraformls = {},

      -- Ansible
      ansiblels = {},

      -- JSON
      jsonls = require 'plugins.lsp.jsonls',

      -- YAML
      yamlls = {},

      -- CSS
      cssls = {},

      -- HTML
      html = {},

      -- Golang
      gopls = {},

      -- Bash
      bashls = {},

      -- VimScript
      vimls = {},

      -- Lua
      sumneko_lua = {
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
      },

      -- Elixir
      elixirls = {
        on_attach = function(client, bufnr)
          -- regular on_attach for lsp
          on_attach(client, bufnr)
          require('elixir').on_attach(client, bufnr)
        end,
      },
    },
  }
end

return M
