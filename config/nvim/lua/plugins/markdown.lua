-- pretty renderer for markdown files
---@type LazySpec
return {
  'MeanderingProgrammer/markdown.nvim',
  ft = { 'markdown' },
  dependencies = { 'dkarter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  opts = {},
}
