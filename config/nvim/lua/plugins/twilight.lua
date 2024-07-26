-- Dim inactive portions of the code (for improved focus)
---@type LazySpec
return {
  'folke/twilight.nvim',
  lazy = true,
  cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
  opts = {},
}
