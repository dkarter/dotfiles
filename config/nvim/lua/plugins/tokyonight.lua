-- TokyoNight color scheme

---@type LazySpec
return {
  'folke/tokyonight.nvim',
  lazy = false, -- make sure we load this during startup
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('tokyonight').setup {
      style = 'moon',
      transparent = true,
    }
    vim.cmd.colorscheme 'tokyonight-moon'
  end,
}
