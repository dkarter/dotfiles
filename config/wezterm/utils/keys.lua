local wezterm = require 'wezterm'
local act = wezterm.action
local M = {}

M.herdr_prefix = function(key)
  return act.SendString('\x1A' .. key)
end

M.herdr_prefix_combo = function(key)
  return act.Multiple {
    act.SendKey { mods = 'CTRL', key = 'z' },
    act.SendKey(key),
  }
end

return M
