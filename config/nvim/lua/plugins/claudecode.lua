-- it's claude code, not claude code
---@type LazySpec
return {
  'coder/claudecode.nvim',
  -- load on start (but delayed) to allow IDE integration from another tmux pane
  -- (/ide)
  event = 'VeryLazy',
  dependencies = { 'folke/snacks.nvim' },
  opts = {},
  keys = require('core.mappings').claudecode_mappings,
}
