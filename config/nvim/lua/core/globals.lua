---@diagnostic disable: undefined-global
_G.I = vim.inspect
_G.fmt = string.format
_G.dbg = function(...)
  Snacks.debug.inspect(...)
end

_G.dd = function(...)
  Snacks.debug.inspect(...)
end
_G.bt = function()
  Snacks.debug.backtrace()
end
vim.print = _G.dd
