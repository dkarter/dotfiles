-- change keyword case (camel case etc), supports LSP rename, which key,
-- motions, etc
---@type LazySpec
return {
  'gregorias/coerce.nvim',
  version = '*',
  dependencies = {
    { 'gregorias/coop.nvim', lazy = true },
  },
  keys = { 'cr', 'gcr' },
  opts = {},
}
