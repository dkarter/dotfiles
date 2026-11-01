-- Rest client for Neovim
---@type LazySpec
return {
  'dkarter/kulala.nvim',
  name = 'kulala-v5.nvim',
  main = 'kulala',
  branch = 'main',
  submodules = false,
  -- Compile our bundled grammar and JS helpers; never fetch upstream binaries.
  build = 'scripts/build.lua',
  keys = {
    { '<leader>rs', desc = 'Send request' },
    { '<leader>ra', desc = 'Send all requests' },
    { '<leader>rb', desc = 'Open scratchpad' },
  },
  ft = { 'http', 'rest' },
  opts = {
    global_keymaps = true,
    global_keymaps_prefix = '<leader>r',
    kulala_keymaps_prefix = '',
    contenttypes = {
      ['application/vnd.api+json'] = {
        ft = 'json',
        formatter = vim.fn.executable 'jq' == 1 and { 'jq', '.' },
        pathresolver = function(...)
          return require('kulala.parser.jsonpath').parse(...)
        end,
      },
    },
  },
}
