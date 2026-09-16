--- integrate with opencode
---@type LazySpec
return {
  'NickvanDyke/opencode.nvim',
  ---@module 'opencode'
  ---@type opencode.Opts
  opts = {},
  config = function(_self, opts)
    -- idk why they do it this way - very weird
    vim.g.opencode_opts = opts

    local select_opts = require('opencode.config').opts.select
    local item_count = 0
    for _, section in ipairs { 'prompts', 'commands', 'server' } do
      item_count = item_count + (select_opts[section] and vim.tbl_count(select_opts[section]) + 1 or 0)
    end

    select_opts.snacks.layout.config = function(layout)
      for _, box in ipairs(layout.layout) do
        if box.win == 'list' and not box.height then
          -- Work around folke/snacks.nvim#2539 until Snacks floors this value upstream.
          box.height = math.max(math.min(item_count, math.floor(vim.o.lines * 0.8 - 10)), 2)
        end
      end
    end
  end,
  keys = require('core.mappings').opencode_mappings,
}
