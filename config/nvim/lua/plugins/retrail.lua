local present, retrail = pcall(require, 'retrail')

if not present then
  return
end

local M = {}

M.setup = function()
  require('retrail').setup {
    -- Highlight group to use for trailing whitespace.
    hlgroup = 'IncSearch',
    -- Enabled filetypes.
    filetype = {
      -- Excluded filetype list. Overrides `include` list.
      exclude = {
        '',
        'TelescopePrompt',
        'Trouble',
        'WhichKey',
        'alpha',
        'checkhealth',
        'diff',
        'fugitive',
        'git',
        'gitcommit',
        'help',
        'lspinfo',
        'lspsagafinder',
        'lspsagaoutline',
        'man',
        'markdown',
        'mason',
        'qf',
        'unite',
      },
    },
  }
end

return M