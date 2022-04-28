local present, feline = pcall(require, 'feline')

if not present then
  return
end

local M = {}

M.setup = function()
  local tokyonight_colors = require('tokyonight.colors').setup { style = 'storm' }

  local colors = {
    bg = tokyonight_colors.bg_statusline,
    fg = tokyonight_colors.fg,
    yellow = tokyonight_colors.yellow,
    cyan = tokyonight_colors.cyan,
    darkblue = tokyonight_colors.blue0,
    green = tokyonight_colors.green,
    orange = tokyonight_colors.orange,
    violet = tokyonight_colors.purple,
    magenta = tokyonight_colors.magenta,
    blue = tokyonight_colors.blue,
    red = tokyonight_colors.red,
    light_bg = tokyonight_colors.bg_highlight,
    primary_blue = tokyonight_colors.blue5,
  }

  local vi_mode_colors = {
    NORMAL = colors.primary_blue,
    OP = colors.primary_blue,
    INSERT = colors.yellow,
    VISUAL = colors.magenta,
    LINES = colors.magenta,
    BLOCK = colors.magenta,
    REPLACE = colors.red,
    ['V-REPLACE'] = colors.red,
    ENTER = colors.cyan,
    MORE = colors.cyan,
    SELECT = colors.orange,
    COMMAND = colors.blue,
    SHELL = colors.green,
    TERM = colors.green,
    NONE = colors.green,
  }

  feline.setup {
    theme = colors,
    vi_mode_colors = vi_mode_colors,
    force_inactive = {
      filetypes = {
        'NvimTree',
        'packer',
        'fugitive',
        'fugitiveblame',
      },
    },
  }
end

return M
