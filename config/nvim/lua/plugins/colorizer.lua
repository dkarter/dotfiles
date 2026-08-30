-- highlight color hex codes with their color (fast!)
---@type LazySpec
return {
  'catgoose/nvim-colorizer.lua',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    filetypes = {
      '*',
      '!lazy',
    },
  },
}
