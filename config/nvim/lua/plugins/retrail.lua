local present, retrail = pcall(require, 'retrail')

if not present then
  return
end

local M = {}

M.setup = function()
  retrail.setup {
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
        'fzf',
        'git',
        'gitcommit',
        'help',
        'lspinfo',
        'lspsagafinder',
        'lspsagaoutline',
        'man',
        'markdown',
        'mason',
        'null-ls-info',
        'qf',
        'unite',
      },
    },
  }
end

return M
