--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

local events = require 'utils.events'
local keys = require 'utils.keys'
local wezterm = require 'wezterm'

-- provides better errors
local config = wezterm.config_builder()

config.font_size = 18
config.command_palette_font_size = 18

config.adjust_window_size_when_changing_font_size = false

-- notify on config reload
wezterm.on('window-config-reloaded', function(window, pane)
  window:toast_notification('wezterm', 'configuration reloaded!', nil, 4000)
end)

-- the MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR is only available on
-- versions starting with 2025
if string.match(wezterm.version, '^2025') ~= nil then
  config.window_decorations =
    'TITLE | RESIZE | MACOS_FORCE_ENABLE_SHADOW | MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR'
end

-- wezterm comes with JetBrains Mono and a default fallback font for symbols
-- so technically, this is not needed. But the fallback symbols are a bit odd
-- looking compared to JetBrains Mono (seem too big or stretched out)
local font_family = 'JetBrainsMono Nerd Font Mono'
config.font = wezterm.font_with_fallback {
  { family = font_family, weight = 'Regular', stretch = 'Normal', style = 'Normal' },
  { family = font_family, weight = 'Regular', stretch = 'Normal', style = 'Italic' },
  { family = font_family, weight = 'Bold', stretch = 'Normal', style = 'Normal' },
  { family = font_family, weight = 'Bold', stretch = 'Normal', style = 'Italic' },
}

if wezterm.gui.get_appearance():find 'Dark' then
  config.color_scheme = 'tokyonight'

  -- that sweet high-contrast dark background
  config.colors = {
    background = '#000000',
  }
else
  config.color_scheme = 'tokyonight_day'
  config.colors = {
    background = '#E1E2E8',
  }
end

-- config.color_scheme = 'tokyonight'

-- disable annoying window close confirmation
config.window_close_confirmation = 'NeverPrompt'

-- disable tab bar (tabs are handled by tmux)
config.enable_tab_bar = false

-- Set the super based on OS
local os_mod

-- most common triples:
local oses = {
  ['x86_64-pc-windows-msvc'] = 'windows',
  -- apple intel
  ['x86_64-apple-darwin'] = 'mac',
  -- apple silicon
  ['aarch64-apple-darwin'] = 'mac',
  ['x86_64-unknown-linux-gnu'] = 'linux',
}

local os = oses[wezterm.target_triple]

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
    mods = (os == 'mac') and 'SUPER' or 'CTRL|SHIFT',
    action = keys.tmux_prefix 'c',
  },

  -- open urls
  {
    key = 'u',
    mods = (os == 'mac') and 'SUPER' or 'CTRL|SHIFT',
    action = keys.tmux_prefix 'u',
  },

  -- vimium like actions
  {
    key = 'f',
    mods = (os == 'mac') and 'SUPER' or 'CTRL|SHIFT',
    action = keys.tmux_prefix 'F',
  },

  -- jump tmux windows
  {
    key = 'k',
    mods = (os == 'mac') and 'SUPER' or 'CTRL|SHIFT',
    action = keys.tmux_prefix 'P',
  },

  -- open sesh - tmux session manager
  {
    key = 'j',
    mods = (os == 'mac') and 'SUPER' or 'CTRL|SHIFT',
    action = keys.tmux_prefix 'T',
  },

  -- toggle to last tmux session
  {
    key = 'l',
    mods = (os == 'mac') and 'SUPER' or 'CTRL|SHIFT',
    action = keys.tmux_prefix 'L',
  },

  -- this requires disabling the app's default keybindings in macOS
  -- Keyboard settings. Also `{` = `[` (it changes because of the Shift key)
  -- https://github.com/wez/wezterm/issues/4251#issuecomment-1718239499
  --
  -- Focus tab (previous)
  {
    key = '{',
    mods = 'SUPER|SHIFT',
    action = keys.tmux_prefix 'p',
  },

  -- Focus tab (next)
  {
    key = '}',
    mods = 'SUPER|SHIFT',
    action = keys.tmux_prefix 'n',
  },

  -- Move tab left
  {
    key = 'LeftArrow',
    mods = (os == 'mac') and 'SUPER|SHIFT' or 'CTRL|SHIFT',
    action = keys.tmux_prefix_combo { key = 'LeftArrow' },
  },

  -- Move tab right
  {
    key = 'RightArrow',
    mods = (os == 'mac') and 'SUPER|SHIFT' or 'CTRL|SHIFT',
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
