local M = {}
local utils = require 'core.utils'

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

local function herdr(args)
  if not utils.in_herdr() then
    return nil
  end

  local command = vim.list_extend({ vim.env.HERDR_BIN_PATH or 'herdr' }, args)
  local output = vim.fn.systemlist(command)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  if #output == 0 then
    return true
  end

  local ok, response = pcall(vim.json.decode, table.concat(output, '\n'))
  if not ok then
    return nil
  end

  return response.result
end

local function process_name(process)
  local command = process.argv0 or process.name or ''
  return string.lower(vim.fn.fnamemodify(command, ':t'):gsub('%.exe$', ''))
end

local function process_info(pane_id)
  local result = herdr { 'pane', 'process-info', '--pane', pane_id }
  return result and result.process_info or nil
end

local function list_panes()
  local workspace_id = vim.env.HERDR_WORKSPACE_ID
  local tab_id = vim.env.HERDR_TAB_ID
  if not workspace_id or not tab_id then
    return {}
  end

  local list_result = herdr { 'pane', 'list', '--workspace', workspace_id }
  local layout_result = herdr { 'pane', 'layout', '--current' }
  if not list_result or not layout_result then
    return {}
  end

  local rects = {}
  for _, pane in ipairs(layout_result.layout.panes or {}) do
    rects[pane.pane_id] = pane.rect
  end

  local panes = {}
  for _, pane in ipairs(list_result.panes or {}) do
    local rect = rects[pane.pane_id]
    if pane.tab_id == tab_id and rect then
      local info = process_info(pane.pane_id)
      local processes = info and info.foreground_processes or {}
      local is_nvim = false
      local busy = info == nil or pane.agent ~= nil

      for _, process in ipairs(processes) do
        local command = process_name(process)
        is_nvim = is_nvim or nvim_commands[command] == true
        busy = busy or shell_commands[command] ~= true
      end

      panes[#panes + 1] = {
        id = pane.pane_id,
        active = pane.pane_id == vim.env.HERDR_PANE_ID,
        busy = busy,
        is_nvim = is_nvim,
        left = rect.x,
        top = rect.y,
      }
    end
  end

  return panes
end

local function pick_opposite_to_nvim(candidates, panes)
  if #candidates == 0 then
    return nil
  end

  local nvim_panes = {}
  for _, pane in ipairs(panes) do
    if pane.is_nvim then
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

  return pick_best(#opposite > 0 and opposite or candidates)
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
  local free = {}
  for _, pane in ipairs(panes) do
    if not pane.busy then
      free[#free + 1] = pane
    end
  end

  return pick_opposite_to_nvim(free, panes)
end

local function choose_anchor_pane(panes)
  local non_nvim = {}
  local nvim_panes = {}

  for _, pane in ipairs(panes) do
    if pane.is_nvim then
      nvim_panes[#nvim_panes + 1] = pane
    else
      non_nvim[#non_nvim + 1] = pane
    end
  end

  local anchor = pick_opposite_to_nvim(non_nvim, panes)
  if anchor then
    return anchor, 'down'
  end

  return pick_best(nvim_panes), 'right'
end

local function create_runner_pane(panes)
  local anchor, direction = choose_anchor_pane(panes)
  if not anchor then
    return nil
  end

  local result = herdr {
    'pane',
    'split',
    anchor.id,
    '--direction',
    direction,
    '--cwd',
    vim.fn.getcwd(),
    '--no-focus',
  }

  return result and result.pane and result.pane.pane_id or nil
end

function M.pick_runner_pane()
  local panes = list_panes()
  local free = choose_free_pane(panes)
  return free and free.id or create_runner_pane(panes)
end

function M.run(cmd)
  local pane_id = M.pick_runner_pane()
  if not pane_id or not herdr { 'pane', 'run', pane_id, cmd } then
    vim.notify('Unable to find or create a Herdr test pane', vim.log.levels.ERROR)
  end
end

return M
