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

-- Enable Zen Mode font size increase from Neovim
-- See https://github.com/folke/zen-mode.nvim#wezterm
wezterm.on('user-var-changed', function(window, pane, name, value)
  local overrides = window:get_config_overrides() or {}
  if name == 'ZEN_MODE' then
    local incremental = value:find '+'
    local number_value = tonumber(value)
    if incremental ~= nil then
      while number_value > 0 do
        window:perform_action(wezterm.action.IncreaseFontSize, pane)
        number_value = number_value - 1
      end
      overrides.enable_tab_bar = false
    elseif number_value < 0 then
      window:perform_action(wezterm.action.ResetFontSize, pane)
      overrides.font_size = nil
      overrides.enable_tab_bar = false
    else
      overrides.font_size = number_value
      overrides.enable_tab_bar = false
    end
  end
  window:set_config_overrides(overrides)
end)

M.toggle_opacity = wezterm.action.EmitEvent 'toggle-opacity'

return M
