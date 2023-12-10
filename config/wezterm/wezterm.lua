local wezterm = require 'wezterm'
local config = {}

config.window_background_opacity = 0.8
config.macos_window_background_blur = 20

-- config.disable_default_key_bindings = true
config.keys = {
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

config.font_size = 18

config.color_scheme = 'tokyonight'

-- that sweet dark background
config.colors = {
  background = '#000000',
}

return config
