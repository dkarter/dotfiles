-- Manage and query databases directly from Neovim
---@type LazySpec[]
return {
  {
    'tpope/vim-dadbod',
    -- keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
    -- dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'DB' },
    lazy = true,
    opts = {},
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_execute_on_save = false
      vim.g.db_ui_disable_mappings = true
      vim.g.db_ui_save_location = './dorians_queries'
      vim.g.db_ui_use_nvim_notify = true
    end,
  },
}
