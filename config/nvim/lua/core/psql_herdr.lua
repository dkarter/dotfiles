local M = {}

local function herdr(args)
  local command = vim.list_extend({ vim.env.HERDR_BIN_PATH or 'herdr' }, args)
  local output = vim.fn.systemlist(command)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  if #output == 0 then
    return true
  end

  local ok, response = pcall(vim.json.decode, table.concat(output, '\n'))
  return ok and response.result or nil
end

local function dollar_quoted_block_under_cursor(bufnr, row, col)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local text = table.concat(lines, '\n')
  local cursor = col + 1
  for index = 1, row - 1 do
    cursor = cursor + #lines[index] + 1
  end

  local offset = 1
  while true do
    local start, delimiter, body_start = text:match('()%f[%a][Dd][Oo]%f[^%a]%s+(%$[%w_]*%$)()', offset)
    if not start then
      return nil
    end

    local closing = text:find(delimiter, body_start, true)
    if closing then
      local after = closing + #delimiter
      local terminator = text:sub(after):match '^%s*();'
      local finish = terminator and after + terminator - 1 or after - 1
      if cursor >= start and cursor <= finish then
        return text:sub(start, finish) .. (terminator and '' or ';')
      end
    end
    offset = body_start
  end
end

local function statement_under_cursor()
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'sql')
  if not ok or not parser then
    return dollar_quoted_block_under_cursor(bufnr, row, col)
  end

  local tree = parser:parse()[1]
  if not tree then
    return dollar_quoted_block_under_cursor(bufnr, row, col)
  end
  local root = tree:root()
  local node = root:named_descendant_for_range(row - 1, col, row - 1, col)
  -- Tree-sitter keeps the terminator outside the statement node.
  if node == root and col > 0 and vim.api.nvim_get_current_line():sub(col + 1, col + 1) == ';' then
    node = root:named_descendant_for_range(row - 1, col - 1, row - 1, col - 1)
  end
  while node and node:type() ~= 'statement' do
    node = node:parent()
  end
  if not node then
    return dollar_quoted_block_under_cursor(bufnr, row, col)
  end

  -- A CTE contains nested statements; execute the whole top-level statement.
  while node do
    local parent = node:parent()
    if not parent or parent:type() == 'program' then
      break
    end
    node = parent
  end
  if not node or node:type() ~= 'statement' then
    return dollar_quoted_block_under_cursor(bufnr, row, col)
  end

  local sql = vim.treesitter.get_node_text(node, bufnr)
  if not sql or sql:match '^%s*$' then
    return nil
  end
  return sql .. ';'
end

local function selected_sql()
  local lines = vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = vim.fn.mode() })
  local sql = table.concat(lines, '\n')
  if sql:match '^%s*$' then
    return nil
  end
  if not sql:match ';%s*$' then
    sql = sql .. ';'
  end
  return sql
end

local function nearest_psql_pane()
  local layout = herdr { 'pane', 'layout', '--current' }
  if not layout or not layout.layout or layout.layout.tab_id ~= vim.env.HERDR_TAB_ID then
    return nil
  end

  local rects = {}
  for _, pane in ipairs(layout.layout.panes or {}) do
    rects[pane.pane_id] = pane.rect
  end
  local current = rects[vim.env.HERDR_PANE_ID]
  if not current then
    return nil
  end

  local panes = herdr { 'pane', 'list', '--workspace', vim.env.HERDR_WORKSPACE_ID }
  if not panes then
    return nil
  end

  local best, distance
  for _, pane in ipairs(panes.panes or {}) do
    local rect = rects[pane.pane_id]
    if pane.tab_id == vim.env.HERDR_TAB_ID and pane.pane_id ~= vim.env.HERDR_PANE_ID and rect then
      local info = herdr { 'pane', 'process-info', '--pane', pane.pane_id }
      local processes = info and info.process_info and info.process_info.foreground_processes or {}
      for _, process in ipairs(processes) do
        local name = vim.fn.fnamemodify(process.argv0 or process.name or '', ':t'):lower():gsub('%.exe$', '')
        if name == 'psql' then
          local dx = (rect.x + rect.width / 2) - (current.x + current.width / 2)
          local dy = (rect.y + rect.height / 2) - (current.y + current.height / 2)
          local candidate_distance = dx * dx + dy * dy
          if not distance or candidate_distance < distance then
            best, distance = pane.pane_id, candidate_distance
          end
          break
        end
      end
    end
  end
  return best
end

local function send_sql(sql)
  if not vim.env.HERDR_PANE_ID or not vim.env.HERDR_WORKSPACE_ID or not vim.env.HERDR_TAB_ID then
    vim.notify('Not running in a Herdr pane', vim.log.levels.WARN)
    return
  end

  if not sql then
    vim.notify('No SQL to send', vim.log.levels.WARN)
    return
  end

  local pane_id = nearest_psql_pane()
  if not pane_id then
    vim.notify('No psql pane found in this Herdr tab', vim.log.levels.WARN)
    return
  end

  if not herdr { 'pane', 'run', pane_id, sql } then
    vim.notify('Unable to send SQL to psql', vim.log.levels.ERROR)
  end
end

function M.send_query()
  send_sql(statement_under_cursor())
end

function M.send_selection()
  send_sql(selected_sql())
end

return M
