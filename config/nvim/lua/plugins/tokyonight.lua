-- TokyoNight color scheme

---@type LazySpec
return {
  'folke/tokyonight.nvim',
  lazy = false, -- make sure we load this during startup
  priority = 1000, -- make sure to load this before all the other start plugins
  ---@module "tokyonight"
  ---@type tokyonight.Config
  opts = {
    style = 'moon',
    transparent = true,
    on_highlights = function(hl, c)
      hl.DapBreakpoint = {
        fg = c.red,
      }
      hl.DapLogPoint = {
        fg = c.blue5,
      }
      hl.DapStopped = {
        fg = c.green1,
      }
    end,
  },
  config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd.colorscheme 'tokyonight-moon'
  end,
}
