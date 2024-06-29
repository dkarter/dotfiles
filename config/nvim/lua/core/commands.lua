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

--- Function to search files using fd and send results to the quickfix list
--- Powers :Cfd
---@param input table command input
local function search_with_fd(input)
  local args = { '--regex', '--hidden', '--type file' }

  -- search on the full path if the command was banged
  if input.bang then
    table.insert(args, '--full-path')
  end

  local cmd = 'fd ' .. table.concat(args, ' ') .. ' ' .. input.args

  -- Run the fd command
  local handle = io.popen(cmd)

  -- a nil check for handle (linter told me to, not sure how this happens)
  if not handle then
    return
  end

  local result = handle:read '*a'
  handle:close()

  -- Split the result into lines
  local lines = {}
  for line in result:gmatch '[^\r\n]+' do
    table.insert(lines, { filename = line, lnum = 1, col = 1, text = line })
  end

  if vim.tbl_isempty(lines) then
    vim.notify 'No results'
  else
    vim.fn.setqflist({}, 'r', { title = 'fd search results', items = lines })
    vim.cmd 'cfirst'
    vim.cmd 'copen'
  end
end

-- searches for files matching the regex pattern and dumps the result in the
-- quickfix list for easy navigation
-- When the command is banged (`:Cfd! something`), then it will search on the
-- full path, not just the file name
cmd('Cfd', search_with_fd, { nargs = '+', complete = 'file', bang = true })
