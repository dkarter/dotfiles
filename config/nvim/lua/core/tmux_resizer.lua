-- Lua implementation of better-vim-tmux-resizer functionality
-- Based on RyanMillerC/better-vim-tmux-resizer

local M = {}

-- Configuration
M.config = {
  resize_count = 5,
  vertical_resize_count = 10,
}

-- Check if we're in tmux
local function in_tmux()
  return vim.env.TMUX ~= nil
end

-- Get tmux executable (tmux or tmate)
local function tmux_executable()
  local tmux = vim.env.TMUX or ''
  return tmux:match 'tmate' and 'tmate' or 'tmux'
end

-- Get tmux socket path
local function tmux_socket()
  local tmux = vim.env.TMUX or ''
  return tmux:match '^([^,]+)'
end

-- Execute tmux command
local function tmux_command(args)
  if not in_tmux() then
    return
  end

  local cmd = string.format('%s -S %s %s', tmux_executable(), tmux_socket(), args)
  vim.fn.system(cmd)
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

  -- Resize Vim window toward given direction, like tmux
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

-- Tmux-aware resize function
local function tmux_aware_resize(direction)
  local previous_window_width = vim.fn.winwidth(0)
  local previous_window_height = vim.fn.winheight(0)

  -- Attempt to resize Vim window
  vim_resize(direction)

  -- Call tmux if Vim window dimensions did not change
  if previous_window_height == vim.fn.winheight(0) and previous_window_width == vim.fn.winwidth(0) then
    local resize_count
    if direction == 'h' or direction == 'l' then
      resize_count = M.config.vertical_resize_count
    else
      resize_count = M.config.resize_count
    end

    -- Convert direction to tmux resize-pane arguments
    local tmux_direction = {
      h = 'L',
      j = 'D',
      k = 'U',
      l = 'R',
    }

    local args = string.format('resize-pane -%s %d', tmux_direction[direction], resize_count)
    tmux_command(args)
  end
end

-- Public API functions
function M.resize_left()
  if in_tmux() then
    tmux_aware_resize 'h'
  else
    vim_resize 'h'
  end
end

function M.resize_down()
  if in_tmux() then
    tmux_aware_resize 'j'
  else
    vim_resize 'j'
  end
end

function M.resize_up()
  if in_tmux() then
    tmux_aware_resize 'k'
  else
    vim_resize 'k'
  end
end

function M.resize_right()
  if in_tmux() then
    tmux_aware_resize 'l'
  else
    vim_resize 'l'
  end
end

-- Setup function to configure resize counts
function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
end

return M
