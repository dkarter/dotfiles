local wezterm = require 'wezterm'
local config = {}

config.font_size = 18

local font_family = 'CaskaydiaCove Nerd Font Mono'

-- wezterm comes with JetBrains Mono and a default fallback font for symbols
-- so technically, this is not needed. But the fallback symbols are a bit odd
-- looking compared to JetBrains Mono (seem too big or stretched out)
config.font = wezterm.font_with_fallback {
  { family = font_family, weight = 'Regular', stretch = 'Normal', style = 'Normal' },
  { family = font_family, weight = 'Regular', stretch = 'Normal', style = 'Italic' },
  { family = font_family, weight = 'Bold', stretch = 'Normal', style = 'Normal' },
  { family = font_family, weight = 'Bold', stretch = 'Normal', style = 'Italic' },
}

config.color_scheme = 'tokyonight'

-- that sweet dark background
config.colors = {
  background = '#000000',
}

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

-- disable tab bar (tabs are handled by tmux)
config.enable_tab_bar = false

-- if enabling this, check https://github.com/stepanzak/dotfiles/blob/main/dot_config/wezterm/wezterm.lua
-- config.disable_default_key_bindings = true
config.keys = {
  {
    key = 'O',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.EmitEvent 'toggle-opacity',
  },
  {
    key = 'P',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.SendString '\x1AP',
  },
  {
    key = 'T',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.SendString '\x1Ac',
  },
  {
    key = '[',
    mods = 'SUPER',
    action = wezterm.action.SendString '\x1Ap',
  },
  {
    key = ']',
    mods = 'SUPER',
    action = wezterm.action.SendString '\x1An',
  },
  {
    key = '1',
    mods = 'SUPER',
    action = wezterm.action.SendString '\x1A1',
  },
  {
    key = '2',
    mods = 'SUPER',
    action = wezterm.action.SendString '\x1A2',
  },
  {
    key = '3',
    mods = 'SUPER',
    action = wezterm.action.SendString '\x1A3',
  },
  {
    key = '4',
    mods = 'SUPER',
    action = wezterm.action.SendString '\x1A4',
  },
  {
    key = '5',
    mods = 'SUPER',
    action = wezterm.action.SendString '\x1A5',
  },
  {
    key = '6',
    mods = 'SUPER',
    action = wezterm.action.SendString '\x1A6',
  },
  {
    key = '7',
    mods = 'SUPER',
    action = wezterm.action.SendString '\x1A7',
  },
  {
    key = '8',
    mods = 'SUPER',
    action = wezterm.action.SendString '\x1A8',
  },
  {
    key = '9',
    mods = 'SUPER',
    action = wezterm.action.SendString '\x1A9',
  },
}

return config
