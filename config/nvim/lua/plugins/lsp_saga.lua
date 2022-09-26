local present, lspsaga = pcall(require, 'lspsaga')

if not present then
  return
end

local M = {}

M.setup = function()
  lspsaga.init_lsp_saga {
    code_action_lightbulb = {
      enable = true,
      sign = true,
      enable_in_insert = true,
      sign_priority = 20,
      virtual_text = false,
    },
  }

  require('core.mappings').lsp_saga_mappings()
end

return M
