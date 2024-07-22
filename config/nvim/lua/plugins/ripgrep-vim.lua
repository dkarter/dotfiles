local core_mappings = require 'core.mappings'

-- RipGrep - grep is dead. All hail the new king RipGrep.
return {
  'jremmen/vim-ripgrep',
  cmd = 'Rg',
  init = function()
    -- allow hidden files to be searched and smart case
    vim.g.rg_command = 'rg --vimgrep --hidden --smart-case'
    vim.g.rg_highlight = 1
  end,
  keys = core_mappings.ripgrep_mappings,
}
