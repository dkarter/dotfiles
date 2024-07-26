-- Convert code to multiline
---@type LazySpec
return {
  'AndrewRadev/splitjoin.vim',
  event = { 'BufReadPost', 'BufNewFile' },
  init = function()
    vim.g.splitjoin_align = 1
    vim.g.splitjoin_trailing_comma = 1
    vim.g.splitjoin_ruby_curly_braces = 0
    vim.g.splitjoin_ruby_hanging_args = 0
  end,
}
