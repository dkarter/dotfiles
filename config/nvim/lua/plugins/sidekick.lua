-- AI integration for neovim
---@type LazySpec
return {
  'folke/sidekick.nvim',
  cmd = 'Sidekick',
  opts = {
    cli = {
      mux = {
        enabled = false,
      },
    },
  },
  config = function(_, opts)
    require('sidekick').setup(opts)
    if vim.env.HERDR_ENV == '1' then
      require('core.sidekick_herdr').setup()
    end
  end,
  keys = require('core.mappings').sidekick_mappings,
}
