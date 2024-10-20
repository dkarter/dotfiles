-- keep your cursor at the center of the screen (without jerkiness)
---@type LazySpec
return {
  'arnamak/stay-centered.nvim',
  event = { 'BufNew', 'BufReadPre' },
  opts = {},
}
