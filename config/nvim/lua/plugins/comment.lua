local present, comment = pcall(require, 'Comment')

if not present then
  return
end

local M = {}

M.setup = function()
  comment.setup {
    pre_hook = function(ctx)
      local U = require 'Comment.utils'
      local utils = require 'ts_context_commentstring.utils'
      local internal = require 'ts_context_commentstring.internal'

      local location = nil
      if ctx.ctype == U.ctype.block then
        location = utils.get_cursor_location()
      elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
        location = utils.get_visual_start_location()
      end

      return internal.calculate_commentstring {
        key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
        location = location,
      }
    end,
  }
end

return M
