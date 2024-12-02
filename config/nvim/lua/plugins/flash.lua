---@type LazySpec
return {
  'folke/flash.nvim',
  -- event = 'VeryLazy',
  ---@module "flash"
  ---@type Flash.Config
  opts = {
    modes = {
      char = {
        enabled = true,
        -- show jump labels
        jump_labels = true,
        highlight = { backdrop = false },
      },
    },
    label = {
      rainbow = {
        enabled = true,
        -- number between 1 and 9
        shade = 5,
      },
    },
    highlight = {
      -- show a backdrop with hl FlashBackdrop
      backdrop = false,
    },
  },
  keys = require('core.mappings').flash_mappings,
}
