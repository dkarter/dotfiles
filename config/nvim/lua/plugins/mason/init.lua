-- installs/updates LSPs, linters and DAPs
---@type LazySpec
return {
  'mason-org/mason.nvim',
  -- temporarily lock to v1 to avoid dealing with breaking changes - after v2
  -- stabilizes this can be updated to 2.0.0 or removed
  version = '^1.0.0',
  build = ':MasonUpdate',
  cmd = { 'Mason', 'MasonUpdate', 'MasonUpdateAll' },
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    -- handles connection of LSP Configs and Mason
    {
      'mason-org/mason-lspconfig.nvim',
      -- temporarily lock to v1 to avoid dealing with breaking changes - after v2
      -- stabilizes this can be updated to 2.0.0 or removed
      version = '^1.0.0',
    },

    -- adds MasonUpdateAll
    {
      'Zeioth/mason-extra-cmds',
      -- temporarily lock to v1 to avoid dealing with breaking changes - after v2
      -- stabilizes this can be updated to 2.0.0 or removed
      version = '^1.0.0',
    },

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
