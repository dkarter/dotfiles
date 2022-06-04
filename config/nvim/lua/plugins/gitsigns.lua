local present, gitsigns = pcall(require, 'gitsigns')

if not present then
  return
end

local default = {
  on_attach = function(bufnr)
    require('core.mappings').gitsigns_mappings(gitsigns, bufnr)

    -- remove background from sign column (so it works better with a transparent
    -- terminal emulator)
    vim.cmd 'hi SignColumn guibg=None'
  end,
}

local M = {}

M.setup = function()
  ---@diagnostic disable-next-line: redundant-parameter
  gitsigns.setup(default)
end

return M
