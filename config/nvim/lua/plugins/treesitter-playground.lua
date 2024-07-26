-- play with TreeShitter
---@type LazySpec
return {
  'nvim-treesitter/playground',
  cmd = 'TSPlaygroundToggle',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
}
