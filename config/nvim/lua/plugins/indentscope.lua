-- Active indent guide and indent text objects. When you're browsing
-- code, this highlights the current level of indentation.
---@type LazySpec
return {
  'echasnovski/mini.indentscope',
  version = false, -- wait till new 0.7.0 release to put it back on semver
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    -- symbol = "▏",
    symbol = '│',
    options = { try_as_border = true },
    draw = {
      -- disable animation, remove to re-enable
      animation = function()
        return 0
      end,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        '',
        'snacks_dashboard',
        'NvimTree',
        'TelescopePrompt',
        'checkhealth',
        'help',
        'lazy',
        'lazyterm',
        'lspinfo',
        'man',
        'mason',
        'notify',
        'nofile',
        'qf',
        'quickfix',
        'terminal',
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
