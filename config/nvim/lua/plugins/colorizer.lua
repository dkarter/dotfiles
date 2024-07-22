-- highlight color hex codes with their color (fast!)
return {
  'norcalli/nvim-colorizer.lua',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    '*',
    '!lazy',
  },
}
