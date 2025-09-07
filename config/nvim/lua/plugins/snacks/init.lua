-- A collection of small QoL plugins for Neovim
---@type LazySpec
return {
  'folke/snacks.nvim',
  priority = 1000,
  keys = require('core.mappings').snack_mappings,
  lazy = false,
  init = function(_self)
    -- Setup some globals for debugging (lazy-loaded)
    _G.dbg = function(...)
      Snacks.debug.inspect(...)
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    _G.bt = function()
      Snacks.debug.backtrace()
    end

    vim.print = _G.dd
  end,
  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    ---@class snacks.indent.Config
    indent = {
      enabled = true,
      animate = { enabled = false },
      -- this is what makes the scope look like an arrow
      chunk = { enabled = true },
    },
    words = { enabled = true },
    ---@class snacks.zen.Config
    zen = { enabled = true },
    scope = { enabled = true },
    input = { enabled = true },
    picker = {
      enabled = true,
      -- replace vim.ui.select
      ui_select = true,
      win = {
        input = {
          keys = {
            -- I use the readline <c-a> to jump to the beginning of the line
            ['<c-a>'] = false,

            -- the default is <c-s> but I'm used to <c-x> from telescope
            ['<c-x>'] = { 'edit_split', mode = { 'i', 'n' } },
          },
        },
      },
      sources = {
        pr_files = {
          title = 'PR Files',
          format = 'text',
          finder = function(_opts, _ctx)
            local main_branch = vim.trim(
              vim.fn.system '{ gh pr view --json baseRefName --jq .baseRefName 2>/dev/null; } || gh repo view --json defaultBranchRef --jq .defaultBranchRef.name'
            )
            local output = vim.fn.systemlist('git diff --name-only ' .. main_branch)
            return vim.tbl_map(function(file)
              return {
                text = file,
                file = file,
                value = file,
              }
            end, output)
          end,
        },
      },
    },
    dashboard = {
      enabled = true,
      preset = {
        ---@type snacks.dashboard.Item[]
        keys = {
          {
            icon = ' ',
            key = 'f',
            desc = 'Find File',
            action = ":lua Snacks.dashboard.pick('files', {hidden = true})",
          },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          {
            icon = ' ',
            key = 'g',
            desc = 'Find Text',
            action = ":lua Snacks.dashboard.pick('live_grep', {hidden = true, need_search = false})",
          },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = ' ',
            key = 'c',
            desc = 'Config',
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = '󰣪 ', key = 'm', desc = 'Mason', action = ':Mason' },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
        -- Used by the `header` section
        header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
    (btw)]],
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
      },
    },
  },
}
