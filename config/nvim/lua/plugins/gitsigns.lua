-- Visual git gutter (also used by feline)
return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    on_attach = function(bufnr)
      require('core.mappings').gitsigns_mappings(bufnr)

      -- remove background from sign column (so it works better with a transparent
      -- terminal emulator)
      vim.cmd 'hi SignColumn guibg=None'
    end,
  },
}
