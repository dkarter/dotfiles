-- abolish.vim: easily search for, substitute, and abbreviate multiple variants
-- of a word
---@type LazySpec
return {
  'tpope/vim-abolish',
  cmd = { 'Abolish', 'Subvert', 'S' },
  init = function()
    -- mappings for coercion will be used by coerce.nvim
    vim.g.abolish_no_mappings = 1
  end,
}
