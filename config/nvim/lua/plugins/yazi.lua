---@type LazySpec
return {
  'mikavilpas/yazi.nvim',
  version = '*', -- use the latest stable version
  event = 'VeryLazy',
  dependencies = {
    { 'nvim-lua/plenary.nvim', lazy = true },
  },
  keys = require('core.mappings').yazi_nvim_mappings,
  ---@module "yazi"
  ---@type YaziConfig | {}
  opts = {
    -- use oil for dirs, not yazi (at least for now) - to use yazi for dirs -
    -- can set this to `true` but will also need to add the init script from the
    -- readme
    open_for_directories = false,
    keymaps = {
      show_help = '<alt-h>',
    },
  },
}
