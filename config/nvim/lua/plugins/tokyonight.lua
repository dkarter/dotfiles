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
    on_highlights = function(hl, colors)
      hl.DapBreakpoint = {
        fg = colors.red,
      }
      hl.DapLogPoint = {
        fg = colors.blue5,
      }
      hl.DapStopped = {
        fg = colors.green1,
      }
      hl.BlinkCmpKindFile = { link = 'LspKindText' } -- FIX wrong bg for icons with source `path`
      hl.BlinkCmpLabelDetail = { link = 'Comment' } -- FIX wrong color
      hl.BlinkCmpLabelDescription = { link = 'NonText' } -- FIX wrong color
      -- hl.BlinkCmpLabelMatch = { fg = colors.yellow } -- make matches stand out more
      hl.BlinkCmpSource = { link = 'NonText', italic = true }
    end,
  },
  config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd.colorscheme 'tokyonight-moon'
  end,
}
