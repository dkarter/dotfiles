-- installs/updates LSPs, linters and DAPs
---@type LazySpec
return {
  'williamboman/mason.nvim',
  build = ':MasonUpdate',
  cmd = { 'Mason', 'MasonUpdate', 'MasonUpdateAll' },
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    -- handles connection of LSP Configs and Mason
    'williamboman/mason-lspconfig.nvim',

    -- adds MasonUpdateAll
    'Zeioth/mason-extra-cmds',

    -- Collection of configurations for the built-in LSP client
    'neovim/nvim-lspconfig',

    -- required for setting up capabilities for cmp
    'hrsh7th/cmp-nvim-lsp',

    -- required for jsonls and yamlls
    { 'b0o/schemastore.nvim', lazy = true },
  },
  config = function()
    require('plugins.mason.lsp').setup()
    require('plugins.mason.setup').setup()
  end,
}
