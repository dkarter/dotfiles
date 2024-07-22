-- Active indent guide and indent text objects. When you're browsing
-- code, this highlights the current level of indentation, and animates
-- the highlighting.
return {
  'echasnovski/mini.indentscope',
  version = false, -- wait till new 0.7.0 release to put it back on semver
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    -- symbol = "▏",
    symbol = '│',
    options = { try_as_border = true },
  },
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        '',
        'alpha',
        'NvimTree',
        'TelescopePrompt',
        'checkhealth',
        'dashboard',
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
