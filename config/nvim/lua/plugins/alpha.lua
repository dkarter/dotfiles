-- start page
---@type LazySpec
return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- Set header
    dashboard.section.header.val = {
      '                                                     ',
      '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
      '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
      '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
      '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
      '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
      '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
      '                                                     ',
    }

    dashboard.section.buttons.val = {
      dashboard.button('f', ' ' .. ' Find file', ':Telescope find_files <CR>'),
      dashboard.button('n', ' ' .. ' New file', ':ene <BAR> startinsert <CR>'),
      dashboard.button('s', ' ' .. ' Git Status files', ':Telescope git_status<CR>'),
      dashboard.button('r', ' ' .. ' Recent files', ':Telescope oldfiles <CR>'),
      dashboard.button('c', ' ' .. ' Config', ":lua require('plugins.telescope').find_dotfiles()<CR>"),
      dashboard.button('m', '󰣪 ' .. ' Mason', ':Mason<CR>'),
      dashboard.button('l', '󰒲 ' .. ' Lazy', ':Lazy<CR>'),
      dashboard.button('q', ' ' .. ' Quit', ':qa<CR>'),
    }

    alpha.setup(dashboard.opts)

    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyVimStarted',
      callback = function()
        local function get_updates()
          local checker = require 'lazy.manage.checker'
          checker.fast_check { report = false }

          local updates
          if require('lazy.status').has_updates() then
            updates = ' (󰁝 ' .. #checker.updated .. ')'
          else
            updates = ''
          end
          return updates
        end

        local stats = require('lazy').stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

      -- stylua: ignore
      dashboard.section.footer.val = '⚡ ' .. stats.count .. ' plugins loaded in ' .. ms .. 'ms' .. get_updates()

        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
