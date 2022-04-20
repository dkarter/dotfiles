local present, bufferline = pcall(require, "bufferline")

if not present then
  return
end

local default = {
  options = {
    numbers = "ordinal",
    diagnostics = "coc",
    always_show_bufferline = false,
  },
}

local M = {}

M.setup = function()
  bufferline.setup(default)
end

return M
