-- A collection of small QoL plugins for Neovim
---@type LazySpec
return {
  'folke/snacks.nvim',
  priority = 1000,
  keys = require('core.mappings').snack_mappings,
  lazy = false,
  ---@module "snacks"
  ---@type snacks.Config
  opts = {},
}