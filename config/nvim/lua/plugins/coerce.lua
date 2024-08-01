-- change keyword case (camel case etc), supports LSP rename, which key,
-- motions, etc
---@type LazySpec
return {
  'gregorias/coerce.nvim',
  version = '*',
  keys = { 'cr', 'gcr' },
  opts = {},
}
