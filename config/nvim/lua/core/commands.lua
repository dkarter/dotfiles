local cmd = vim.api.nvim_create_user_command
local utils = require 'core.utils'

cmd('PrettyPrintJSON', '%!jq', {})
cmd('PrettyPrintXML', '!tidy -mi -xml -wrap 0 %', {})
cmd('PrettyPrintHTML', '!tidy -mi -xml -wrap 0 %', {})
cmd('BreakLineAtComma', ':normal! f,a<CR><esc>', {})
cmd('Retab', ':set ts=2 sw=2 et<CR>:retab<CR>', {})
cmd('CopyFullName', "let @+=expand('%')", {})
cmd('CopyPath', "let @+=expand('%:h')", {})
cmd('CopyFileName', "let @+=expand('%:t')", {})

cmd('ReloadModules', utils.reload_modules, {})

local function grepFileNames(opts)
  local bang = opts.bang or false
  local args = opts.args or ''
  local grepprg = vim.api.nvim_get_option 'grepprg'
  local grepformat = vim.api.nvim_get_option 'grepformat'
  local shellpipe = vim.api.nvim_get_option 'shellpipe'

  vim.api.nvim_set_option('grepprg', 'fd')
  vim.api.nvim_set_option('grepformat', '%f')

  if shellpipe == '2>&1| tee' or shellpipe == '|& tee' then
    vim.api.nvim_set_option('shellpipe', '| tee')
  end

  vim.api.nvim_command('silent grep! ' .. args)

  if bang == false and not vim.fn.empty(vim.fn.getqflist()) then
    vim.schedule(function()
      vim.api.nvim_command 'cfirst'
    end)
  end

  vim.api.nvim_set_option('grepprg', grepprg)
  vim.api.nvim_set_option('grepformat', grepformat)
  vim.api.nvim_set_option('shellpipe', shellpipe)
end

-- searches for files matching the regex pattern and dumps the result in the
-- quickfix list for easy navigation
cmd('Cfd', grepFileNames, { nargs = '+', complete = 'file', bang = true })
