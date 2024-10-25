-- Neovim file explorer: edit your filesystem like a buffer
---@type LazySpec
return {
  'stevearc/oil.nvim',
  -- we need this to work when running nvim .
  -- it's ok though because this only adds ~1.5ms to load time
  event = { 'VimEnter' },
  keys = require('core.mappings').oil_nvim_mappings,
  ---@module "oil"
  ---@class oil.Config
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    columns = { 'icon' },
    keymaps = {
      ['<C-h>'] = false,
      ['<S-CR>'] = 'actions.select_split',
    },
    ---@diagnostic disable-next-line: missing-fields
    view_options = {
      show_hidden = true,
      natural_order = true,
      is_always_hidden = function(name, _bufnr)
        return name == '..' or name == '.git'
      end,
    },
  },
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
