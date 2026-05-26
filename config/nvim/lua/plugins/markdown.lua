-- pretty renderer for markdown files
---@type LazySpec
return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown', 'codecompanion' },
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  opts = {},
}
