-- displays a popup with possible key bindings e.g. <leader>f will show f as
-- the next possible character
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  ---@class wk.Opts
  opts = {
    preset = 'modern',
    plugins = {
      spelling = { enabled = false },
    },
  },
}
