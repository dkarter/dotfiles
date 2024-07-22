-- automatically set color scheme based on system
return {
  'f-person/auto-dark-mode.nvim',
  event = 'VeryLazy',
  opts = {
    update_interval = 1000,
    set_dark_mode = function()
      vim.api.nvim_set_option_value('background', 'dark', { scope = 'global' })

      vim.cmd.colorscheme 'tokyonight-moon'

      -- only change theme on lualine if it's loaded
      if package.loaded['lualine'] then
        ---@diagnostic disable-next-line: redundant-parameter
        require('lualine').setup { options = { theme = 'tokyonight-moon' } }
      end
    end,
    set_light_mode = function()
      vim.api.nvim_set_option_value('background', 'light', { scope = 'global' })

      vim.cmd.colorscheme 'tokyonight-day'

      -- only change theme on lualine if it's loaded
      if package.loaded['lualine'] then
        ---@diagnostic disable-next-line: redundant-parameter
        require('lualine').setup { options = { theme = 'tokyonight-day' } }
      end
    end,
  },
}
