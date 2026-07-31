-- Use the correct comment string for embedded languages
---@type LazySpec
return {
  'JoosepAlviste/nvim-ts-context-commentstring',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = { enable_autocmd = false },
  config = function(_self, opts)
    require('ts_context_commentstring').setup(opts)

    local get_option = vim.filetype.get_option
    vim.filetype.get_option = function(filetype, option)
      return option == 'commentstring' and require('ts_context_commentstring').calculate_commentstring()
        or get_option(filetype, option)
    end
  end,
}
