return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {
    modes = {
      char = {
        enabled = false,
      },
    },
    label = {
      rainbow = {
        enabled = true,
        -- number between 1 and 9
        shade = 5,
      },
    },
  },
    -- stylua: ignore
    keys = require('core.mappings').flash_mappings,
}
