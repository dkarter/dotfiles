vim.opt.runtimepath:prepend 'config/nvim'
vim.env.HERDR_PANE_ID = 'w1:p1'
vim.env.HERDR_TAB_ID = 'w1:t1'
vim.env.HERDR_WORKSPACE_ID = 'w1'

local sent = {}
local processes = { ['w1:p2'] = 'psql', ['w1:p3'] = 'psql', ['w1:p4'] = 'zsh' }
local layout = {
  tab_id = 'w1:t1',
  panes = {
    { pane_id = 'w1:p1', rect = { x = 0, y = 0, width = 50, height = 40 } },
    { pane_id = 'w1:p2', rect = { x = 50, y = 0, width = 50, height = 20 } },
    { pane_id = 'w1:p3', rect = { x = 50, y = 20, width = 50, height = 20 } },
    { pane_id = 'w1:p4', rect = { x = 0, y = 40, width = 50, height = 20 } },
  },
}

vim.fn.systemlist = function(args)
  local result
  if args[2] == 'pane' and args[3] == 'layout' then
    result = { layout = layout }
  elseif args[2] == 'pane' and args[3] == 'list' then
    result = {
      panes = {
        { pane_id = 'w1:p1', tab_id = 'w1:t1' },
        { pane_id = 'w1:p2', tab_id = 'w1:t1' },
        { pane_id = 'w1:p3', tab_id = 'w1:t1' },
        { pane_id = 'w1:p4', tab_id = 'w1:t1' },
        { pane_id = 'w1:p5', tab_id = 'w1:t2' },
      },
    }
  elseif args[2] == 'pane' and args[3] == 'process-info' then
    result = { process_info = { foreground_processes = { { argv0 = processes[args[5]] } } } }
  elseif args[2] == 'pane' and args[3] == 'run' then
    sent[#sent + 1] = { pane = args[4], sql = args[5] }
    return {} -- Herdr's successful pane run has no output.
  else
    error('Unexpected Herdr call: ' .. vim.inspect(args))
  end
  return { vim.json.encode { result = result } }
end

local notices = {}
vim.notify = function(message)
  notices[#notices + 1] = message
end

local function check(lines, row, col, expected_pane, expected_sql)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(0, { row, col })
  require('core.psql_herdr').send_query()
  local last = sent[#sent]
  assert(last and last.pane == expected_pane, vim.inspect(last))
  assert(last.sql == expected_sql, vim.inspect(last.sql))
  assert(#notices == 0, vim.inspect(notices))
end

check({ 'select 1;', 'select 2;' }, 2, 3, 'w1:p2', 'select 2;')
check({ 'select 1;' }, 1, 8, 'w1:p2', 'select 1;')
check({ 'with x as (select 1)', 'select * from x;' }, 1, 18, 'w1:p2', 'with x as (select 1)\nselect * from x;')

local block = {
  'select 1;',
  'do $$',
  'begin',
  "    if current_database() not like '%_shard1' then",
  "        raise exception 'Connect directly to Shard 1 before removing the global copy';",
  '    end if;',
  'end',
  '$$;',
}
check(block, 5, 12, 'w1:p2', table.concat(vim.list_slice(block, 2), '\n'))
check(block, 8, 2, 'w1:p2', table.concat(vim.list_slice(block, 2), '\n'))

vim.g.mapleader = ' '
dofile 'config/nvim/after/ftplugin/sql.lua'
assert(vim.fn.maparg('<leader>dq', 'x') ~= '')
vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'select 1;', 'select 2;' })
vim.cmd 'normal! gg0v$'
vim.api.nvim_feedkeys(' dq', 'xt', false)
assert(sent[#sent].sql == 'select 1;', vim.inspect(sent[#sent]))
assert(#notices == 0, vim.inspect(notices))

vim.cmd 'normal! gg0Vj'
vim.api.nvim_feedkeys(' dq', 'xt', false)
assert(sent[#sent].sql == 'select 1;\nselect 2;', vim.inspect(sent[#sent]))
assert(#notices == 0, vim.inspect(notices))

vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'select 12345;' })
vim.cmd 'normal! gg0v8l'
vim.api.nvim_feedkeys(' dq', 'xt', false)
assert(sent[#sent].sql == 'select 12;', vim.inspect(sent[#sent]))
assert(#notices == 0, vim.inspect(notices))

processes['w1:p2'] = 'zsh'
check({ 'select 3;' }, 1, 2, 'w1:p3', 'select 3;')
processes['w1:p3'] = 'zsh'
local count = #sent
require('core.psql_herdr').send_query()
assert(#sent == count and notices[#notices] == 'No psql pane found in this Herdr tab')

vim.api.nvim_buf_set_lines(0, 0, -1, false, { '-- nothing to run' })
vim.api.nvim_win_set_cursor(0, { 1, 3 })
require('core.psql_herdr').send_query()
assert(#sent == count and notices[#notices] == 'No SQL to send')

print 'psql_herdr tests passed'
