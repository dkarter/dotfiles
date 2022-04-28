local present, gitsigns = pcall(require, 'gitsigns')

if not present then
  return
end

local default = {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end, { expr = true })

    -- Text object for git hunks (e.g. vih will select the hunk)
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')

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
