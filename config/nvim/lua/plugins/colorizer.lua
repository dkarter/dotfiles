-- highlight color hex codes with their color (fast!)
---@type LazySpec
return {
  'norcalli/nvim-colorizer.lua',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    '*',
    '!lazy',
  },
}
