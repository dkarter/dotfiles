local default = {
  defaults = {
    results_title = false,
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    prompt_prefix = '   ',
    selection_caret = '  ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    selection_strategy = 'reset',
    sorting_strategy = 'ascending',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_ignore_patterns = { 'node_modules' },
    path_display = { 'truncate' },
    winblend = 0,
    border = {},
    borderchars = require('core.utils').get_border_chars 'none',
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' },
  },
  pickers = {
    find_files = {
      find_command = {
        'fd',
        '--type',
        'f',
        '--strip-cwd-prefix',
        '--hidden',
        '--follow',
        '-E',
        '.git',
        '--ignore-file',
        '~/.gitignore',
      },
    },
  },
  extensions = {
    conventional_commits = {
      -- insert a conventional_commit label from telescope + scope
      action = function(entry)
        local msg = string.format('%s()', entry.value)
        vim.api.nvim_set_current_line(msg)
        vim.api.nvim_win_set_cursor(0, { 1, string.len(msg) - 1 })

        vim.ui.input({ prompt = 'Scope? (optional)' }, function(scope)
          local new_msg = entry.value

          -- scope is nil if dialog is aborted
          if scope then
            new_msg = string.format('%s(%s)', new_msg, scope)
          end

          new_msg = string.format('%s: ', new_msg)

          -- update the line
          vim.api.nvim_set_current_line(new_msg)

          vim.api.nvim_win_set_cursor(0, { 1, string.len(new_msg) + 1 })
        end)

        -- place cursor at the end of the line in insert mode
        vim.cmd [[:normal $a]]
      end,
    },
  },
}

local apply_highlights = function()
  local colors = require('tokyonight.colors').setup { style = 'moon' }
  local util = require 'tokyonight.util'
  -- not sure why lua ls cannot see this field.. it's there..
  ---@diagnostic disable-next-line: undefined-field
  local results_bg = util.darken(colors.bg_highlight, 0.2)

  local TelescopePrompt = {
    TelescopePreviewNormal = {
      bg = util.darken(colors.bg_dark, 0.8),
    },
    TelescopePreviewBorder = {
      bg = util.darken(colors.bg_dark, 0.8),
    },
    TelescopePromptNormal = {
      bg = '#2d3149',
    },
    TelescopePromptBorder = {
      bg = '#2d3149',
    },
    TelescopePromptTitle = {
      fg = util.lighten('#2d3149', 0.8),
      bg = '#2d3149',
    },
    TelescopePreviewTitle = {
      fg = colors.info,
      bg = colors.bg_dark,
    },
    TelescopeResultsTitle = {
      fg = colors.bg_dark,
      bg = results_bg,
    },
    TelescopeResultsNormal = {
      bg = results_bg,
    },
    TelescopeResultsBorder = {
      bg = results_bg,
    },
  }

  for hl, col in pairs(TelescopePrompt) do
    vim.api.nvim_set_hl(0, hl, col)
  end
end

local M = {}

M.find_dotfiles = function()
  require('telescope.builtin').find_files {
    shorten_path = false,
    cwd = '~/dotfiles/',
    prompt = '~ dotfiles ~',
    hidden = true,

    layout_strategy = 'horizontal',
    layout_config = {
      preview_width = 0.55,
    },
  }
end

M.setup = function()
  local telescope = require 'telescope'

  ---@diagnostic disable-next-line: redundant-parameter
  telescope.setup(default)

  local extensions = {
    'gh',
    'file_browser',
    'fzf',
    'conventional_commits',
  }

  for _, e in ipairs(extensions) do
    telescope.load_extension(e)
  end

  apply_highlights()
end

return M
