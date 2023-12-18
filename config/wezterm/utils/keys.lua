local wezterm = require 'wezterm'
local M = {}

M.tmux_prefix = function(tmux_key)
  -- equivalent to Ctrl-z + tmux_key
  return wezterm.action.SendString('\x1A' .. tmux_key)
end

return M
