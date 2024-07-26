-- Automatically highlights other instances of the word under your cursor.
-- This works with LSP, Treesitter, and regexp matching to find the other
-- instances.
---@type LazySpec
return {
  'RRethy/vim-illuminate',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    delay = 200,
    filetypes_denylist = {
      'dirbuf',
      'dirvish',
      'fugitive',
      'gotmpl',
    },
    large_file_cutoff = 2000,
    large_file_overrides = {
      providers = { 'lsp' },
    },
  },
  -- this is a good example of how to have both `opts` and `config`
  config = function(_, opts)
    require('illuminate').configure(opts)
  end,
}
