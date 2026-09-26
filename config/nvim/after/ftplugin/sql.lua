vim.keymap.set('n', '<leader>dq', function()
  require('core.psql_herdr').send_query()
end, { buffer = true, desc = 'Send SQL query to nearest Herdr psql pane' })

vim.keymap.set('x', '<leader>dq', function()
  require('core.psql_herdr').send_selection()
end, { buffer = true, desc = 'Send selected SQL to nearest Herdr psql pane' })
