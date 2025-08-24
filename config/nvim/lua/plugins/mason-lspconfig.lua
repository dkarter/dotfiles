-- Sets up LSPs from Mason automatically
---@type LazySpec
return {
  'mason-org/mason-lspconfig.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'mason-org/mason.nvim',
    -- Collection of configurations for the built-in LSP client
    {
      'neovim/nvim-lspconfig',
      -- blink is needed for setting up capabilities in core.lsp
      dependencies = { 'saghen/blink.cmp' },
    },

    -- NOTE: not sure if this is needed anymore
    --
    -- required for setting up capabilities for cmp
    -- 'hrsh7th/cmp-nvim-lsp',

    -- required for jsonls and yamlls
    { 'b0o/schemastore.nvim', lazy = true },
  },
  opts = {
    automatic_enable = true,
  },
  config = function(_self, opts)
    require('core.lsp').setup()
    require('mason-lspconfig').setup(opts)
  end,
}
