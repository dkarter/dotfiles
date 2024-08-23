-- elixir lsp support
---@type LazySpec
return {
  'elixir-tools/elixir-tools.nvim',
  version = '*',
  ft = { 'elixir', 'heex', 'eelixir' },
  config = function()
    local elixir = require 'elixir'
    local elixirls = require 'elixir.elixirls'

    elixir.setup {
      nextls = {
        enable = false,
        -- installed via mason
        cmd = 'nextls',
        init_options = {
          mix_env = 'dev',
          mix_target = 'host',
          experimental = {
            completions = {
              enable = true,
            },
          },
        },
        on_attach = function(client, bufnr)
          require('core.mappings').elixir_mappings()
          require('plugins.mason.lsp').on_attach(client, bufnr)
        end,
      },
      credo = { enable = true },
      elixirls = {
        enable = true,
        settings = elixirls.settings {
          dialyzerEnabled = true,
          enableTestLenses = false,
        },
        on_attach = function(client, bufnr)
          require('core.mappings').elixir_mappings()
          require('plugins.mason.lsp').on_attach(client, bufnr)
        end,
      },
    }
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
}
