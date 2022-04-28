local present, telescope = pcall(require, 'telescope')

if not present then
  return
end

local default = {
  defaults = {
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
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
  },
  extensions = {
    conventional_commits = {
      -- insert a conventional_commit label from telescope + scope
      action = function(entry)
        vim.ui.input({ prompt = 'Scope ? (optional) ' }, function(scope)
          local msg = entry.value

          if scope then
            msg = string.format('%s(%s)', msg, scope)
          end

          msg = string.format('%s: ', msg)

          -- update the line
          vim.api.nvim_set_current_line(msg)
          -- place cursor at the end of the line in insert mode
          vim.cmd [[:normal A]]
        end)
      end,
    },
  },
}

local M = {}

M.setup = function()
  telescope.setup(default)

  local extensions = {
    'gh',
    'file_browser',
    'packer',
    'fzf',
    'conventional_commits',
  }

  for _, e in ipairs(extensions) do
    telescope.load_extension(e)
  end

  require('core.mappings').telescope_mappings()
end

return M
