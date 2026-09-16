-- AI integration for neovim
---@type LazySpec
return {
  'folke/sidekick.nvim',
  opts = {
    cli = {
      mux = {
        enabled = false,
      },
    },
  },
  keys = require('core.mappings').sidekick_mappings,
}
