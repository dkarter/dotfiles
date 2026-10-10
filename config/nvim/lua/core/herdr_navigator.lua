local M = {}

function M.navigate(vim_direction, herdr_direction)
  local navigator = require 'herdr-navigator'
  local window = vim.api.nvim_get_current_win()
  local config = vim.api.nvim_win_get_config(window)

  -- Snacks sidebar content floats over a real split. wincmd from the float
  -- returns to the editor even when moving away from the sidebar's outer edge.
  if vim.bo.filetype:match '^snacks_picker_' and config.relative == 'win' then
    local anchor = assert(config.win)
    while vim.api.nvim_win_get_config(anchor).relative == 'win' do
      anchor = assert(vim.api.nvim_win_get_config(anchor).win)
    end
    if vim.api.nvim_win_get_config(anchor).relative == '' then
      -- win_call avoids WinEnter, which would refocus Snacks' floating list.
      local neighbor = vim.api.nvim_win_call(anchor, function()
        return vim.fn.win_getid(vim.fn.winnr(vim_direction))
      end)
      if neighbor == anchor then
        navigator.focus_herdr_pane(herdr_direction)
      else
        vim.api.nvim_set_current_win(neighbor)
      end
      return
    end
  end

  navigator.navigate(vim_direction, herdr_direction)
end

return M
