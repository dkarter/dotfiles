local present, lspsaga = pcall(require, 'lspsaga')

if not present then
  return
end

local M = {}

M.setup = function()
  ---@diagnostic disable-next-line: redundant-parameter
  lspsaga.setup {
    lightbulb = {
      enable = true,
      sign = true,
      enable_in_insert = false,
      sign_priority = 40,
      virtual_text = false,
    },
    symbol_in_winbar = {
      enable = false,
    },
  }

  require('core.mappings').lsp_saga_mappings()
end

return M
