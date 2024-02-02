local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

local function font(opts)
  return wezterm.font_with_fallback {
    opts,
    { family = 'Symbols Nerd Font Mono', scale = 0.9 },
  }
end

wezterm.on('update-status', function(window, pane)
  local cells = {}

  -- "Wed Mar 3 08:14"
  local active_key_table = window:active_key_table()

  local mode = wezterm.format {
    { Text = active_key_table or '' },
  }

  local date = wezterm.strftime '%a %b %-d %H:%M '
  local date_status = wezterm.format {
    { Text = wezterm.nerdfonts.fa_clock_o .. ' ' .. date },
  }

  local workspace = window:active_workspace()

  if active_key_table then
    table.insert(cells, mode)
  end

  table.insert(cells, date_status)

  -- this is not the right way to get those symbols, see https://wezfurlong.org/wezterm/config/lua/window/set_right_status.html
  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = ''

  -- Color palette for the backgrounds of each cell
  local colors = {
    '#3c1361',
    '#52307c',
    '#663a82',
    '#7c5295',
    '#b491c8',
  }

  -- Foreground color for the text across the fade
  local text_fg = '#c0c0c0'

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  local function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
    if not is_last then
      table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_left_status(' ' .. workspace .. ' ')
  window:set_right_status(wezterm.format(elements))
end)

config.color_scheme = 'tokyonight'

config.window_frame = {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected hqere, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
  font = font { family = 'Cascadia Mono', weight = 'Bold' },

  -- The size of the font in the tab bar.
  -- Default to 10. on Windows but 12.0 on other systems
  font_size = 18.0,
}

config.colors = {
  tab_bar = {
    -- The color of the strip that goes along the top of the window
    -- (does not apply when fancy tab bar is in use)
    background = '#0b0022',

    -- The active tab is the one that has focus in the window
    active_tab = {
      -- The color of the background area for the tab
      bg_color = '#2b2042',
      -- The color of the text for the tab
      fg_color = '#c0c0c0',

      -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
      -- label shown for this tab.
      -- The default is "Normal"
      intensity = 'Normal',

      -- Specify whether you want "None", "Single" or "Double" underline for
      -- label shown for this tab.
      -- The default is "None"
      underline = 'None',

      -- Specify whether you want the text to be italic (true) or not (false)
      -- for this tab.  The default is false.
      italic = false,

      -- Specify whether you want the text to be rendered with strikethrough (true)
      -- or not for this tab.  The default is false.
      strikethrough = false,
    },

    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
      bg_color = '#1b1032',
      fg_color = '#808080',

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
      bg_color = '#3b3052',
      fg_color = '#909090',
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab_hover`.
    },

    -- The new tab button that let you create new tabs
    new_tab = {
      bg_color = '#1b1032',
      fg_color = '#808080',

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over the new tab button
    new_tab_hover = {
      bg_color = '#3b3052',
      fg_color = '#909090',
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab_hover`.
    },
  },
}

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- # Typography
--
config.font = font { family = 'Cascadia Mono' }
-- config.font = font("CaskaydiaCove Nerd Font Mono")
config.font_size = 18

-- For beautiful terminal add background blur
-- But when needing to concentrate, nothing beats a solid background
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20

local mod = 'SHIFT|SUPER'

-- simulate leader in TMux for muscle memory, eventually this can be changed to
-- Space + something
-- config.leader = { key = "z", mods = "CTRL" }

local keymaps = {
  -- { mods = "CTRL", key = "k", action = act.ActivatePaneDirection("Up") },
  -- { mods = "CTRL", key = "j", action = act.ActivatePaneDirection("Down") },
  -- { mods = "CTRL", key = "l", action = act.ActivatePaneDirection("Right") },
  -- { mods = "CTRL", key = "h", action = act.ActivatePaneDirection("Left") },
  { mods = mod, key = 't', action = act.SpawnTab 'CurrentPaneDomain' },
  { mods = mod, key = '|', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { mods = mod, key = '_', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { mods = mod, key = '>', action = act.MoveTabRelative(1) },
  { mods = mod, key = '<', action = act.MoveTabRelative(-1) },
  { mods = mod, key = 'M', action = act.TogglePaneZoomState },
  { mods = mod, key = 'p', action = act.PaneSelect { alphabet = '', mode = 'Activate' } },
  { mods = mod, key = 'C', action = act.CopyTo 'ClipboardAndPrimarySelection' },
  { mods = mod, key = 'd', action = wezterm.action.ShowDebugOverlay },

  -- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
  -- mode until we cancel that mode.
  {
    key = 'r',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'resize_pane',
      one_shot = false,
    },
  },

  {
    key = 'S',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      -- Here you can dynamically construct a longer list if needed

      wezterm.log_info 'HIIIIIIIIII'
      local home = wezterm.home_dir
      local workspaces = {
        { id = home, label = 'Home' },
        { id = home .. '/dev', label = 'Dev' },
        { id = home .. '/Notes', label = 'Notes' },
        { id = home .. '/dotfiles', label = 'Config' },
      }

      window:perform_action(
        act.InputSelector {
          action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
            if not id and not label then
              wezterm.log_info 'cancelled'
            else
              wezterm.log_info('id = ' .. id)
              wezterm.log_info('label = ' .. label)
              inner_window:perform_action(
                act.SwitchToWorkspace {
                  name = label,
                  spawn = {
                    label = 'Workspace: ' .. label,
                    cwd = id,
                  },
                },
                inner_pane
              )
            end
          end),
          title = 'Choose Workspace',
          choices = workspaces,
          fuzzy = true,
          fuzzy_description = 'Fuzzy find and/or make a workspace',
        },
        pane
      )
    end),
  },

  -- tmux muscle memory compatibility mappings
  { mods = 'LEADER', key = '\\', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { mods = 'LEADER', key = '-', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { mods = 'LEADER', key = '[', action = act.ActivateCopyMode },
  { mods = 'LEADER', key = ']', action = act.PasteFrom 'Clipboard' },
  { mods = 'LEADER', key = 'Space', action = act.ShowLauncher },
}

config.keys = keymaps

config.key_tables = {
  -- Defines the keys that are active in our resize-pane mode.
  -- Since we're likely to want to make multiple adjustments,
  -- we made the activation one_shot=false. We therefore need
  -- to define a key assignment for getting out of this mode.
  -- 'resize_pane' here corresponds to the name="resize_pane" in
  -- the key assignments above.
  resize_pane = {
    { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },

    { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },

    { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },

    { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 1 } },
    { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },

    -- Cancel the mode by pressing escape
    { key = 'Escape', action = 'PopKeyTable' },
  },
}

config.bold_brightens_ansi_colors = true
config.cell_width = 0.9
config.scrollback_lines = 10000
config.hyperlink_rules = {
  -- Linkify things that look like URLs and the host has a TLD name.
  -- Compiled-in default. Used if you don't specify any hyperlink_rules.
  {
    regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b',
    format = '$0',
  },

  -- linkify email addresses
  -- Compiled-in default. Used if you don't specify any hyperlink_rules.
  {
    regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
    format = 'mailto:$0',
  },

  -- file:// URI
  -- Compiled-in default. Used if you don't specify any hyperlink_rules.
  {
    regex = [[\bfile://\S*\b]],
    format = '$0',
  },

  -- Linkify things that look like URLs with numeric addresses as hosts.
  -- E.g. http://127.0.0.1:8000 for a local development server,
  -- or http://192.168.1.1 for the web interface of many routers.
  {
    regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
    format = '$0',
  },

  -- Make username/project paths clickable. This implies paths like the following are for GitHub.
  -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
  -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
  {
    regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
    format = 'https://www.github.com/$1/$3',
  },
}

return config
