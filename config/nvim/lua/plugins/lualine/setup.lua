local present, lualine = pcall(require, 'lualine')

if not present then
  return
end

local stl_escape = function(str)
  if type(str) ~= 'string' then
    return str
  end
  return str:gsub('%%', '%%%%')
end

local M = {}

M.setup = function()
  local tokyonight_colors = require('tokyonight.colors').setup { style = 'moon' }

  ---@diagnostic disable:undefined-field
  local colors = {
    black = tokyonight_colors.fg,
    green = tokyonight_colors.green,
    grey = tokyonight_colors.bg_highlight,
    light_green = tokyonight_colors.hint,
    orange = tokyonight_colors.orange,
    red = tokyonight_colors.red,
    white = tokyonight_colors.bg_statusline,
    actual_white = '#f3f3f3',
  }
  ---@diagnostic enable:undefined-field

  local empty = require('lualine.component'):extend()
  function empty:draw(default_highlight)
    self.status = ''
    self.applied_separator = ''
    self:apply_highlights(default_highlight)
    self:apply_section_separators()
    return self.status
  end

  -- Put proper separators and gaps between components in sections
  local function process_sections(sections)
    for name, section in pairs(sections) do
      local left = name:sub(9, 10) < 'x'

      for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
        table.insert(section, pos * 2, { empty, color = { fg = colors.white, bg = colors.white } })
      end

      for id, comp in ipairs(section) do
        if type(comp) ~= 'table' then
          comp = { comp }
          section[id] = comp
        end
        comp.separator = left and { right = '' } or { left = '' }
      end
    end

    return sections
  end

  local function search_result()
    if vim.v.hlsearch == 0 then
      return ''
    end

    local last_search = vim.fn.getreg '/'

    if not last_search or last_search == '' then
      return ''
    end

    local searchcount = vim.fn.searchcount { maxcount = 9999 }

    return stl_escape(last_search) .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
  end

  local function modified()
    if vim.bo.modified then
      return '+'
    elseif vim.bo.modifiable == false or vim.bo.readonly == true then
      return '-'
    end
    return ''
  end

  local function location()
    local line = vim.fn.line '.'
    local col = vim.fn.virtcol '.'
    return string.format(' %d,  %d', line, col)
  end

  local function is_recording()
    local name = vim.api.nvim_call_function('reg_recording', {})
    return name ~= ''
  end

  local function get_recording_name()
    return '⏺️ Rec @' .. vim.api.nvim_call_function('reg_recording', {})
  end

  local winbar = {
    lualine_a = {
      {
        'filetype',
        colored = true, -- Displays filetype icon in color if set to true
        icon_only = true, -- Display only an icon for filetype
        icon = { align = 'right' }, -- Display filetype icon on the right hand side
        color = { bg = colors.grey, fg = colors.black },
        padding = { left = 1, right = 0 },
        -- icon =    {'X', align='right'}
        -- Icon string ^ in table is ignored in filetype component
      },
      {
        'filename',
        separator = { right = '' },
        padding = { left = 0, right = 1 },
        color = { bg = colors.grey, fg = colors.black },
      },
    },
    lualine_b = {
      {
        'navic',
        color_correction = 'static',
        navic_opts = nil,
        separator = { right = ' ' },
      },
    },
    lualine_c = {},
    lualine_x = {
      -- show available plugin updates
      {
        require('lazy.status').updates,
        cond = require('lazy.status').has_updates,
        color = { fg = '#ff9e64' },
      },
    },
    lualine_y = {},
    lualine_z = {},
  }

  ---@module "lualine"
  lualine.setup {
    winbar = winbar,
    inactive_winbar = {
      lualine_a = {
        {
          'filetype',
          colored = false, -- Displays filetype icon in color if set to true
          icon_only = true, -- Display only an icon for filetype
          icon = { align = 'right' }, -- Display filetype icon on the right hand side
          padding = { left = 1, right = 0 },
          color = { fg = colors.grey },
        },
        {
          'filename',
          separator = { right = '' },
          padding = { left = 0, right = 1 },
          color = { fg = colors.grey },
        },
      },
    },
    options = {
      theme = 'tokyonight-moon',
      component_separators = '',
      section_separators = { left = '', right = '' },
    },
    sections = process_sections {
      lualine_a = {
        {
          'mode',
          fmt = function(str)
            return str:sub(1, 1)
          end,
        },
      },
      lualine_b = {
        'branch',
        'diff',
        {
          'diagnostics',
          source = { 'nvim' },
          sections = { 'error' },
          diagnostics_color = { error = { bg = colors.red, fg = colors.actual_white } },
        },
        {
          'diagnostics',
          source = { 'nvim' },
          sections = { 'warn' },
          diagnostics_color = { warn = { bg = colors.orange, fg = colors.actual_white } },
        },
        { 'filename', file_status = false, path = 1 },
        { modified, color = { bg = colors.red, fg = colors.actual_white } },
        {
          '%w',
          cond = function()
            return vim.wo.previewwindow
          end,
        },
        {
          '%r',
          cond = function()
            return vim.bo.readonly
          end,
        },
        {
          '%q',
          cond = function()
            return vim.bo.buftype == 'quickfix'
          end,
        },
      },
      lualine_c = {},
      lualine_x = {
        {
          get_recording_name,
          cond = is_recording,
          color = { fg = '#ff9e64' },
        },
      },
      lualine_y = { search_result, 'filetype' },
      lualine_z = { location, '%p%%/%L' },
    },
    inactive_sections = {
      lualine_c = { '%f %y %m' },
      lualine_x = {},
    },
  }
end

return M
