local wezterm = require 'wezterm'
local M = {}

wezterm.on('toggle-opacity', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.8
    overrides.macos_window_background_blur = 20
  else
    overrides.window_background_opacity = nil
    overrides.macos_window_background_blur = nil
  end
  window:set_config_overrides(overrides)
end)

M.toggle_opacity = wezterm.action.EmitEvent 'toggle-opacity'

return M
