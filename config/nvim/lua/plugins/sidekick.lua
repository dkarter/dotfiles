-- AI integration for neovim
---@type LazySpec
return {
  'folke/sidekick.nvim',
  opts = {
    cli = {
      mux = {
        backend = 'tmux',
        enabled = true,
        create = 'split',
      },
    },
  },
  keys = require('core.mappings').sidekick_mappings,
}
