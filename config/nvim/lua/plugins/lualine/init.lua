-- status line + winbar

---@type LazySpec
return {
  'nvim-lualine/lualine.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    {
      'SmiteshP/nvim-navic',
      dependencies = { 'neovim/nvim-lspconfig' },
      opts = {
        highlight = true,
      },
    },
  },
  config = function()
    require('plugins.lualine.setup').setup()
  end,
}
