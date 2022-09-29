_G.I = vim.inspect
_G.fmt = string.format
_G.dbg = function(thing)
  vim.notify(I(thing))
end
