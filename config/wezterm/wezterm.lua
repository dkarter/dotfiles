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

-- provides better errors
config = wezterm.config_builder()

config.font_size = 18
config.command_palette_font_size = 18

local font_family = 'CaskaydiaCove Nerd Font Mono'

config.adjust_window_size_when_changing_font_size = false

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
  -- activate WezTerm's Command Palette
  {
    key = 'P',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.ActivateCommandPalette,
  },

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
    action = keys.tmux_prefix 'c',
  },

  -- open urls
  {
    key = 'u',
    mods = 'SUPER',
    action = keys.tmux_prefix 'u',
  },

  -- jump tmux windows
  {
    key = 'k',
    mods = 'SUPER',
    action = keys.tmux_prefix 'P',
  },

  -- open t - tmux smart session manager
  {
    key = 'j',
    mods = 'SUPER',
    action = keys.tmux_prefix 'T',
  },

  -- this requires disabling the app's default keybindings in macOS
  -- Keyboard settings. Also `{` = `[` (it changes because of the Shift key)
  -- https://github.com/wez/wezterm/issues/4251#issuecomment-1718239499
  --
  -- Focus tab (previous)
  {
    key = '{',
    mods = 'CMD|SHIFT',
    action = keys.tmux_prefix 'p',
  },

  -- Focus tab (next)
  {
    key = '}',
    mods = 'CMD|SHIFT',
    action = keys.tmux_prefix 'n',
  },

  -- Move tab left
  {
    key = 'LeftArrow',
    mods = 'SUPER|SHIFT',
    action = keys.tmux_prefix_combo { key = 'LeftArrow' },
  },

  -- Move tab right
  {
    key = 'RightArrow',
    mods = 'SUPER|SHIFT',
    action = keys.tmux_prefix_combo { key = 'RightArrow' },
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
