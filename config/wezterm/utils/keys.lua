local wezterm = require 'wezterm'
local act = wezterm.action
local M = {}

M.tmux_prefix = function(tmux_key)
  -- equivalent to Ctrl-z + tmux_key
  return act.SendString('\x1A' .. tmux_key)
end

M.tmux_prefix_combo = function(tmux_key)
  return act.Multiple {
    act.SendKey { mods = 'CTRL', key = 'z' },
    act.SendKey(tmux_key),
  }
end

return M
