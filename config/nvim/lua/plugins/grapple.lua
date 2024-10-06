-- immediate navigation to important files
---@type LazySpec
return {
  'cbochs/grapple.nvim',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons', lazy = true },
  },
  keys = require('core.mappings').grapple_mappings,
  ---@module "grapple"
  ---@type grapple.settings
  opts = {
    scope = 'git_branch', -- can try 'git' if that's not great
    icons = true,
  },
}
