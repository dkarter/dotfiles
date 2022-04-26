local present, trouble = pcall(require, 'trouble')

if not present then
  return
end

local M = {}

M.setup = function()
  trouble.setup()
  require('core.mappings').trouble_mappings()
end

return M
