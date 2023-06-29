local present, lspsaga = pcall(require, 'lspsaga')

if not present then
  return
end

local M = {}

M.setup = function()
  ---@diagnostic disable-next-line: redundant-parameter
  lspsaga.setup {
    code_action_lightbulb = {
      enable = true,
      sign = true,
      enable_in_insert = false,
      sign_priority = 20,
      virtual_text = false,
    },
    symbol_in_winbar = {
      enable = false,
    },
  }

  require('core.mappings').lsp_saga_mappings()
end

return M
