---@type LazySpec
return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@module "flash"
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
  keys = require('core.mappings').flash_mappings,
}
