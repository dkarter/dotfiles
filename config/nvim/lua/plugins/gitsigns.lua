-- Visual git gutter (also used by feline)
---@type LazySpec
return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = require('core.mappings').gitsigns_mappings,
  opts = {},
  init = function(_self)
    -- remove background from sign column (so it works better with a transparent
    -- terminal emulator)
    vim.cmd 'hi SignColumn guibg=None'
  end,
}
