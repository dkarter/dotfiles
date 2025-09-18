-- Manage and query databases directly from Neovim
---@type LazySpec[]
return {
  {
    'tpope/vim-dadbod',
    cmd = { 'DB' },
    lazy = true,
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      {
        'kristijanhusak/vim-dadbod-completion',
        ft = { 'sql', 'mysql', 'plsql' },
        lazy = true,
        init = function()
          vim.g.vim_dadbod_completion_lowercase_keywords = true
        end,
      },
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
      vim.g.db_ui_execute_on_save = true
      vim.g.db_ui_save_location = '~/.local/share/nvim/dadbod'
      vim.g.db_ui_use_nvim_notify = true
    end,
  },
}
