local M = {}

local shell_commands = {
  bash = true,
  fish = true,
  nu = true,
  pwsh = true,
  sh = true,
  zsh = true,
}

local nvim_commands = {
  nvim = true,
  vim = true,
}

local pick_best

local function tmux(args)
  if not vim.env.TMUX then
    return nil
  end

  local command = vim.g.VimuxTmuxCommand or 'tmux'
  local cmd = vim.list_extend(vim.split(command, ' ', { trimempty = true }), args)
  local output = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end

  return output
end

local function list_panes()
  local lines = tmux {
    'list-panes',
    '-F',
    '#{pane_id}\t#{pane_active}\t#{pane_current_command}\t#{pane_left}\t#{pane_top}\t#{pane_pid}\t#{pane_tty}\t#{pane_current_path}',
  }

  if not lines then
    return {}
  end

  local panes = {}
  for _, line in ipairs(lines) do
    local parts = vim.split(line, '\t', { plain = true })
    if #parts >= 8 then
      local command = string.lower(parts[3])
      panes[#panes + 1] = {
        id = parts[1],
        active = parts[2] == '1',
        command = command,
        left = tonumber(parts[4]) or 0,
        top = tonumber(parts[5]) or 0,
        pid = tonumber(parts[6]),
        tty = parts[7],
        path = parts[8],
      }
    end
  end

  return panes
end

local function is_nvim(pane)
  return nvim_commands[pane.command] == true
end

local function tty_name(tty)
  if not tty or tty == '' then
    return nil
  end

  return tty:gsub('^/dev/', '')
end

local function foreground_command_for_tty(tty)
  local name = tty_name(tty)
  if not name then
    return nil
  end

  local lines = vim.fn.systemlist { 'ps', '-o', 'state=', '-o', 'comm=', '-t', name }
  if vim.v.shell_error ~= 0 or #lines == 0 then
    return nil
  end

  local fallback
  for _, line in ipairs(lines) do
    local state, command = line:match '^%s*(%S+)%s+(.+)%s*$'
    if state and command then
      local normalized = string.lower(vim.fn.fnamemodify(command, ':t'))
      fallback = normalized
      if state:find '%+' then
        return normalized
      end
    end
  end

  return fallback
end

local function process_children_map()
  if not vim or not vim.fn then
    return {}
  end

  local lines = vim.fn.systemlist { 'ps', '-axo', 'pid=', '-o', 'ppid=' }
  if vim.v.shell_error ~= 0 or #lines == 0 then
    return {}
  end

  local children_by_parent = {}
  for _, line in ipairs(lines) do
    local pid, ppid = line:match '^%s*(%d+)%s+(%d+)%s*$'
    if pid and ppid then
      local parent = tonumber(ppid)
      local child = tonumber(pid)
      if parent and child then
        local list = children_by_parent[parent]
        if not list then
          list = {}
          children_by_parent[parent] = list
        end
        list[#list + 1] = child
      end
    end
  end

  return children_by_parent
end

local function descendant_count(root_pid, children_by_parent)
  if not root_pid then
    return 0
  end

  local total = 0
  local queue = { root_pid }
  local i = 1
  while i <= #queue do
    local current = queue[i]
    i = i + 1
    local children = children_by_parent[current]
    if children then
      for _, child in ipairs(children) do
        total = total + 1
        queue[#queue + 1] = child
      end
    end
  end

  return total
end

local function is_busy_shell(pane)
  if descendant_count(pane.pid, pane.children_by_parent or {}) > 0 then
    return true
  end

  local foreground = foreground_command_for_tty(pane.tty)
  if not foreground then
    return false
  end

  return shell_commands[foreground] ~= true
end

local function is_free_shell(pane)
  if shell_commands[pane.command] ~= true then
    return false
  end

  if pane.busy ~= nil then
    return not pane.busy
  end

  return not is_busy_shell(pane)
end

local function pick_opposite_to_nvim(candidates, panes)
  if #candidates == 0 then
    return nil
  end

  local nvim_panes = {}
  for _, pane in ipairs(panes) do
    if is_nvim(pane) then
      nvim_panes[#nvim_panes + 1] = pane
    end
  end

  if #nvim_panes == 0 then
    return pick_best(candidates)
  end

  table.sort(nvim_panes, function(a, b)
    if a.active ~= b.active then
      return a.active
    end
    return a.id < b.id
  end)

  local nvim = nvim_panes[1]
  local min_left = panes[1].left
  local max_left = panes[1].left
  for i = 2, #panes do
    min_left = math.min(min_left, panes[i].left)
    max_left = math.max(max_left, panes[i].left)
  end

  if min_left == max_left then
    return pick_best(candidates)
  end

  local preferred_left = nvim.left == min_left and max_left or min_left
  local opposite = {}
  for _, pane in ipairs(candidates) do
    if pane.left == preferred_left then
      opposite[#opposite + 1] = pane
    end
  end

  if #opposite > 0 then
    return pick_best(opposite)
  end

  return pick_best(candidates)
end

pick_best = function(candidates)
  table.sort(candidates, function(a, b)
    if a.left ~= b.left then
      return a.left > b.left
    end
    if a.top ~= b.top then
      return a.top < b.top
    end
    return a.id < b.id
  end)

  return candidates[1]
end

local function choose_free_pane(panes)
  local children_by_parent = process_children_map()
  local free = {}
  for _, pane in ipairs(panes) do
    pane.children_by_parent = children_by_parent
    if is_free_shell(pane) then
      free[#free + 1] = pane
    end
  end

  return pick_opposite_to_nvim(free, panes)
end

local function choose_anchor_pane(panes)
  local non_nvim = {}
  local nvim_panes = {}

  for _, pane in ipairs(panes) do
    if is_nvim(pane) then
      nvim_panes[#nvim_panes + 1] = pane
    else
      non_nvim[#non_nvim + 1] = pane
    end
  end

  local anchor = pick_opposite_to_nvim(non_nvim, panes)
  if anchor then
    return anchor, 'v'
  end

  return pick_best(nvim_panes), 'h'
end

local function create_runner_pane(panes)
  local anchor, split_direction = choose_anchor_pane(panes)
  if not anchor then
    return nil
  end

  local args = {
    'split-window',
    '-' .. split_direction,
    '-t',
    anchor.id,
    '-c',
    vim.fn.getcwd(),
    '-P',
    '-F',
    '#{pane_id}',
  }

  local result = tmux(args)
  if not result or #result == 0 then
    return nil
  end

  return result[1]
end

local function plan_runner(panes)
  local free = choose_free_pane(panes)
  if free then
    return {
      action = 'reuse',
      pane_id = free.id,
    }
  end

  local anchor, split_direction = choose_anchor_pane(panes)
  if not anchor then
    return {
      action = 'none',
    }
  end

  return {
    action = 'split',
    anchor_id = anchor.id,
    split_direction = split_direction,
  }
end

function M.pick_runner_pane()
  local panes = list_panes()
  local plan = plan_runner(panes)
  if plan.action == 'reuse' then
    return plan.pane_id
  end

  if plan.action == 'split' then
    return create_runner_pane(panes)
  end

  return nil
end

function M.run(cmd)
  local pane_id = M.pick_runner_pane()
  if pane_id then
    vim.g.VimuxRunnerIndex = pane_id
  end

  vim.fn['test#strategy#vimux'](cmd)
end

function M._plan_runner(panes)
  return plan_runner(panes)
end

return M
