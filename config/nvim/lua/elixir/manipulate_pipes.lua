local M = {}

local get_cursor_position = function()
  local rowcol = vim.api.nvim_win_get_cursor(0)
  local row = rowcol[1] - 1
  local col = rowcol[2]

  return row, col
end

local function apply_refactor_action(client, title_patterns)
  local found = false

  vim.lsp.buf.code_action {
    apply = true,
    context = {
      diagnostics = vim.diagnostic.get(0),
      only = { 'refactor', 'refactor.rewrite' },
    },
    filter = function(action, action_client_id)
      if action_client_id ~= client.id then
        return false
      end

      local title = (action.title or ''):lower()

      for _, pattern in ipairs(title_patterns) do
        if title:find(pattern, 1, true) then
          found = true
          return true
        end
      end

      return false
    end,
  }

  return found
end

local manipulate_pipes = function(direction, client)
  if client and client.name == 'elixirls' then
    local row, col = get_cursor_position()

    client.request_sync('workspace/executeCommand', {
      command = 'manipulatePipes:serverid',
      arguments = { direction, 'file://' .. vim.api.nvim_buf_get_name(0), row, col },
    }, nil, 0)

    return
  end

  local ok

  if direction == 'toPipe' then
    ok = apply_refactor_action(client, { 'introduce pipe', 'to pipe' })
  else
    ok = apply_refactor_action(client, { 'remove pipe', 'from pipe' })
  end

  if not ok then
    vim.notify('No matching pipe refactor action available at cursor', vim.log.levels.WARN)
  end
end

function M.from_pipe(client)
  return function()
    manipulate_pipes('fromPipe', client)
  end
end

function M.to_pipe(client)
  return function()
    manipulate_pipes('toPipe', client)
  end
end

return M
