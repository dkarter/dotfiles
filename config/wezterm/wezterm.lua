--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

local wezterm = require 'wezterm'
local events = require 'utils.events'
local keys = require 'utils.keys'

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

-- disable annoying window close confirmation
config.window_close_confirmation = 'NeverPrompt'

-- disable tab bar (tabs are handled by tmux)
config.enable_tab_bar = false

-- if enabling this, check https://github.com/stepanzak/dotfiles/blob/main/dot_config/wezterm/wezterm.lua
-- config.disable_default_key_bindings = true
config.keys = {
  -- toggle opacity and blur
  {
    key = 'O',
    mods = 'SUPER|SHIFT',
    action = events.toggle_opacity,
  },

  -- open new tab
  {
    key = 'T',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.SendString '\x1Ac',
  },

  -- open urls
  {
    key = 'u',
    mods = 'SUPER',
    action = wezterm.action.SendString '\x1Au',
  },

  -- jump tmux windows
  {
    key = 'k',
    mods = 'SUPER',
    action = wezterm.action.SendString '\x1AP',
  },

  -- open t - tmux smart session manager
  {
    key = 'j',
    mods = 'SUPER',
    action = wezterm.action.SendString '\x1AT',
  },

  -- this requires disabling the app's default keybindings in macOS
  -- Keyboard settings. Also `{` = `[` (it changes because of the Shift key)
  -- https://github.com/wez/wezterm/issues/4251#issuecomment-1718239499
  {
    key = '{',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SendString '\x1Ap',
  },

  {
    key = '}',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SendString '\x1An',
  },
}

-- add SUPER + <1 - 9> for navigating tabs
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'SUPER',
    action = keys.tmux_prefix(i),
  })
end

return config
