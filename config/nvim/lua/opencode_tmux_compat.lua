local M = {}

---@param cmd string[]
---@return string
local function run(cmd)
  local result = vim.system(cmd, { text = true }):wait()
  if result.code ~= 0 then
    return ''
  end

  return (result.stdout or ''):gsub('%s+$', '')
end

---@param cmd string[]
---@return string[]
local function run_lines(cmd)
  local output = run(cmd)
  if output == '' then
    return {}
  end

  return vim.split(output, '\n', { plain = true, trimempty = true })
end

---@param args string
---@return integer?
local function parse_target_port(args)
  local attach_port = args:match '%-%-attach=.-:(%d+)'
    or args:match '%-%-attach%s+.-:(%d+)'
    or args:match 'attach%s+.-:(%d+)'
  if attach_port then
    return tonumber(attach_port)
  end

  local cli_port = args:match '%-%-port=(%d+)' or args:match '%-%-port%s+(%d+)'
  if cli_port then
    return tonumber(cli_port)
  end

  return nil
end

---@param pid string
---@return integer[]
local function listening_ports(pid)
  local ports = {}
  local seen = {}

  for _, line in ipairs(run_lines { 'lsof', '-w', '-iTCP', '-sTCP:LISTEN', '-P', '-n', '-a', '-p', pid }) do
    local port = tonumber(line:match ':(%d+)%s*%(LISTEN%)')
    if port and not seen[port] then
      seen[port] = true
      table.insert(ports, port)
    end
  end

  return ports
end

---@return table<string, { pane_index: integer, pane_title: string }>, integer?
local function sibling_panes_by_tty()
  if vim.fn.executable 'tmux' ~= 1 or vim.env.TMUX == nil then
    return {}, nil
  end

  local current_pane = run { 'tmux', 'display-message', '-p', '#{pane_id}' }
  local current_index = tonumber(run { 'tmux', 'display-message', '-p', '#{pane_index}' })
  local siblings = {}

  for _, line in
    ipairs(run_lines { 'tmux', 'list-panes', '-F', '#{pane_id}\t#{pane_tty}\t#{pane_index}\t#{pane_title}' })
  do
    local pane_id, pane_tty, pane_index, pane_title = line:match '^(%%%d+)\t([^\t]+)\t([^\t]+)\t(.*)$'
    if pane_id and pane_tty and pane_id ~= current_pane then
      siblings[pane_tty:gsub('^/dev/', '')] = {
        pane_index = tonumber(pane_index) or 0,
        pane_title = pane_title or '',
      }
    end
  end

  return siblings, current_index
end

---@return integer[]
local function preferred_sibling_ports()
  local siblings, current_index = sibling_panes_by_tty()
  if vim.tbl_isempty(siblings) then
    return {}
  end

  local preferred_by_tty = {}
  for _, process in ipairs(run_lines { 'ps', '-eo', 'pid=,tty=,args=' }) do
    local pid, tty, args = process:match '^%s*(%d+)%s+(%S+)%s+(.+)$'
    if pid and tty and args and tty ~= '??' and args:find('opencode', 1, true) and siblings[tty] then
      local ports = {}
      local parsed_port = parse_target_port(args)
      if parsed_port then
        table.insert(ports, parsed_port)
      end

      vim.list_extend(ports, listening_ports(pid))

      if #ports > 0 then
        local pane = siblings[tty]
        local candidate = preferred_by_tty[tty]
        local distance = math.abs((pane.pane_index or 0) - (current_index or 0))
        if not candidate or distance < candidate.distance then
          preferred_by_tty[tty] = {
            distance = distance,
            pane_index = pane.pane_index or 0,
            ports = ports,
          }
        end
      end
    end
  end

  local panes = vim.tbl_values(preferred_by_tty)
  table.sort(panes, function(a, b)
    if a.distance ~= b.distance then
      return a.distance < b.distance
    end
    return a.pane_index < b.pane_index
  end)

  local ordered_ports = {}
  local seen = {}
  for _, pane in ipairs(panes) do
    for _, port in ipairs(pane.ports) do
      if not seen[port] then
        seen[port] = true
        table.insert(ordered_ports, port)
        break
      end
    end
  end

  return ordered_ports
end

function M.apply()
  local ok, discovery = pcall(require, 'opencode-tmux.discovery')
  if not ok or discovery._dk_prefer_single_pane then
    return
  end

  local original_servers_from_ports = discovery.servers_from_ports
  local original_sibling_ports = discovery.sibling_ports

  discovery.sibling_ports = function()
    local ports = preferred_sibling_ports()
    if #ports > 0 then
      return ports
    end

    return original_sibling_ports()
  end

  discovery.sibling_servers = function()
    return original_servers_from_ports(discovery.sibling_ports())
  end

  discovery._dk_prefer_single_pane = true
end

return M
