-- RipGrep - grep is dead. All hail the new king RipGrep.
---@type LazySpec
return {
  'jremmen/vim-ripgrep',
  cmd = 'Rg',
  init = function()
    -- allow hidden files to be searched and smart case
    vim.g.rg_command = 'rg --vimgrep --hidden --smart-case'
    vim.g.rg_highlight = 1
  end,
  keys = require('core.mappings').ripgrep_mappings,
}
