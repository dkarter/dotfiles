-- Resize Neovim windows first, then fall through to the surrounding Herdr pane.

local M = {}
local utils = require 'core.utils'

-- Configuration
M.config = {
  resize_count = 5,
  vertical_resize_count = 10,
}

local function in_herdr()
  return utils.in_herdr()
end

local function herdr_resize(direction)
  local args = { vim.env.HERDR_BIN_PATH or 'herdr', 'pane', 'resize', '--direction', direction }
  local pane_id = vim.env.HERDR_PANE_ID
  if pane_id and pane_id ~= '' then
    vim.list_extend(args, { '--pane', pane_id })
  else
    args[#args + 1] = '--current'
  end
  vim.system(args, { text = true }, function() end)
end

-- Vim window resize logic
local function vim_resize(direction)
  -- Prevent resizing Vim upward when there is only a single window
  if direction == 'j' and vim.fn.winnr '$' <= 1 then
    return
  end

  -- Prevent resizing Vim upwards when all windows are vsplit
  if direction == 'k' or direction == 'j' then
    local all_windows_are_vsplit = true
    for window = 1, vim.fn.winnr '$' do
      if vim.fn.win_screenpos(window)[1] ~= 1 then
        all_windows_are_vsplit = false
        break
      end
    end
    if all_windows_are_vsplit then
      return
    end
  end

  -- Resize the Neovim window toward the given direction.
  local current_window_is_last_window = (vim.fn.winnr() == vim.fn.winnr '$')
  local modifier
  if direction == 'h' or direction == 'k' then
    modifier = current_window_is_last_window and '+' or '-'
  else
    modifier = current_window_is_last_window and '-' or '+'
  end

  local command, window_resize_count
  if direction == 'h' or direction == 'l' then
    command = 'vertical resize'
    window_resize_count = M.config.vertical_resize_count
  else
    command = 'resize'
    window_resize_count = M.config.resize_count
  end

  vim.cmd(command .. ' ' .. modifier .. window_resize_count)
end

local function herdr_aware_resize(direction)
  local previous_window_width = vim.fn.winwidth(0)
  local previous_window_height = vim.fn.winheight(0)

  -- Attempt to resize Vim window
  vim_resize(direction)

  -- Resize the surrounding Herdr pane if the Neovim window did not change.
  if previous_window_height == vim.fn.winheight(0) and previous_window_width == vim.fn.winwidth(0) then
    local directions = { h = 'left', j = 'down', k = 'up', l = 'right' }
    if in_herdr() then
      herdr_resize(directions[direction])
    end
  end
end

local function resize(direction)
  if in_herdr() then
    herdr_aware_resize(direction)
    return
  end

  vim_resize(direction)
end

function M.resize_left()
  resize 'h'
end
function M.resize_down()
  resize 'j'
end
function M.resize_up()
  resize 'k'
end
function M.resize_right()
  resize 'l'
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
end

return M
