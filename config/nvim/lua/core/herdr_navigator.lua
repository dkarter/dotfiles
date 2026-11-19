local M = {}
local handoff_pending = false

function M.in_native_herdr()
  return not require('core.utils').in_herdr() and vim.env.HC_TERMINAL_ID ~= nil and vim.fn.executable 'herdr-app' == 1
end

function M.enabled()
  return require('core.utils').in_herdr() or M.in_native_herdr()
end

local function focus_herdr_pane(direction)
  if not M.in_native_herdr() then
    require('herdr-navigator').focus_herdr_pane(direction)
    return
  end

  -- An hc terminal can also run without the app, or be shown in an inactive tab.
  -- Only switch panes if this editor still owns the app's focused pane.
  if handoff_pending then
    return
  end
  handoff_pending = true
  local address = vim.env.HC_TERMINAL_ID
  local options = { text = true, timeout = 1000 }
  vim.system({ 'herdr-app', 'ls' }, options, function(list)
    if list.code ~= 0 then
      handoff_pending = false
      return
    end
    local parsed, layout = pcall(vim.json.decode, list.stdout)
    if not parsed then
      handoff_pending = false
      return
    end
    for _, space in ipairs(layout.spaces or {}) do
      for _, tab in ipairs(space.tabs or {}) do
        for _, terminal in ipairs(tab.terminals or {}) do
          if terminal.terminal == address then
            vim.system({ 'herdr-app', 'status' }, options, function(status)
              local ok, current = pcall(vim.json.decode, status.stdout)
              if status.code ~= 0 or not ok or current.focused_pane ~= terminal.pane then
                handoff_pending = false
                return
              end
              vim.system({ 'herdr-app', 'do', 'pane.go', '--direction', direction }, options, function()
                handoff_pending = false
              end)
            end)
            return
          end
        end
      end
    end
    handoff_pending = false
  end)
end

function M.navigate(vim_direction, herdr_direction)
  local window = vim.api.nvim_get_current_win()
  local config = vim.api.nvim_win_get_config(window)

  -- Snacks sidebar content floats over a real split. wincmd from the float
  -- returns to the editor even when moving away from the sidebar's outer edge.
  if vim.bo.filetype:match '^snacks_picker_' and config.relative == 'win' then
    local anchor = assert(config.win)
    while vim.api.nvim_win_get_config(anchor).relative == 'win' do
      anchor = assert(vim.api.nvim_win_get_config(anchor).win)
    end
    if vim.api.nvim_win_get_config(anchor).relative == '' then
      -- win_call avoids WinEnter, which would refocus Snacks' floating list.
      local neighbor = vim.api.nvim_win_call(anchor, function()
        return vim.fn.win_getid(vim.fn.winnr(vim_direction))
      end)
      if neighbor == anchor then
        focus_herdr_pane(herdr_direction)
      else
        vim.api.nvim_set_current_win(neighbor)
      end
      return
    end
  end

  if not M.in_native_herdr() then
    require('herdr-navigator').navigate(vim_direction, herdr_direction)
  elseif pcall(vim.cmd.wincmd, vim_direction) and vim.api.nvim_get_current_win() == window then
    focus_herdr_pane(herdr_direction)
  end
end

function M.navigate_terminal(vim_direction, herdr_direction)
  if not M.in_native_herdr() then
    require('herdr-navigator').navigate_terminal(vim_direction, herdr_direction)
    return
  end

  vim.cmd.stopinsert()
  M.navigate(vim_direction, herdr_direction)
end

function M.keymaps()
  local keys = {}
  for _, entry in ipairs {
    { 'h', 'left' },
    { 'j', 'down' },
    { 'k', 'up' },
    { 'l', 'right' },
  } do
    local key, direction = unpack(entry)
    keys[#keys + 1] = {
      '<C-' .. key .. '>',
      function()
        M.navigate(key, direction)
      end,
      mode = { 'n', 'x', 's' },
      desc = 'Navigate ' .. direction,
    }
    keys[#keys + 1] = {
      '<C-' .. key .. '>',
      function()
        M.navigate_terminal(key, direction)
      end,
      mode = 't',
      desc = 'Navigate ' .. direction,
    }
  end
  return keys
end

return M
