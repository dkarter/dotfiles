-- fuzzy find things
---@type LazySpec
return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-telescope/telescope-github.nvim',
    'olacin/telescope-cc.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'folke/tokyonight.nvim',
    'nvim-telescope/telescope-symbols.nvim',
    -- Telescope uses treesitter for previews
    'dkarter/nvim-treesitter',
  },
  config = function()
    require('plugins.telescope.setup').setup()
  end,
  keys = require('core.mappings').telescope_mappings,
}
