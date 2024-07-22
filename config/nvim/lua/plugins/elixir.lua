-- elixir lsp support
return {
  'elixir-tools/elixir-tools.nvim',
  version = '*',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local elixir = require 'elixir'
    local elixirls = require 'elixir.elixirls'

    elixir.setup {
      nextls = { enable = false },
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
