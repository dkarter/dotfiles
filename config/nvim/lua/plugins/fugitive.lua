-- git integration
---@type LazySpec
return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  config = function()
    require('core.mappings').fugitive_mappings()

    local augroup = require('core.utils').augroup

    augroup('FugitiveUser', {
      -- add custom bindings for Git Blame buffer
      {
        event = { 'FileType' },
        pattern = { 'fugitiveblame' },
        command = function()
          vim.keymap.set('n', 'q', ':q<CR>', { noremap = true, buffer = true, desc = 'Close Blame' })
        end,
      },
    })
  end,
}
