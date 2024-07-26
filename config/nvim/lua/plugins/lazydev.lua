---@type LazySpec
return {
  'folke/lazydev.nvim',
  cmd = { 'LazyDev' },
  ft = 'lua',
  ---@module "lazydev"
  ---@class lazydev.Config
  opts = {
    library = {
      { 'lazy.nvim', words = { 'lazy', 'LazySpec', 'LazyKeys', 'LazyKeysSpec' } },
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      -- Load the wezterm types when the `wezterm` module is required
      -- Needs `justinsgithub/wezterm-types` to be installed
      { path = 'wezterm-types', mods = { 'wezterm' } },
    },
  },
  dependencies = {
    -- vim.uv typings
    { 'Bilal2453/luvit-meta', lazy = true },

    -- wezterm typings
    { 'justinsgithub/wezterm-types', lazy = true },
  },
}
