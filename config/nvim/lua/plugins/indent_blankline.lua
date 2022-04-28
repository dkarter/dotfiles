local present, indent_blankline = pcall(require, 'indent_blankline')

if not present then
  return
end

local default = {
  char = '│',
  filetype_exclude = {
    'TelescopePrompt',
    'dashboard',
    'NvimTree',
    'packer',
    'terminal',
    'nofile',
    'quickfix',
    'lspinfo',
    'checkhealth',
    'help',
    'man',
    '',
  },
}

local M = {}

M.setup = function()
  ---@diagnostic disable-next-line: redundant-parameter
  indent_blankline.setup(default)
end

return M
