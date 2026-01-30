-- Neovim as a language server to inject LSP diagnostics, code
-- actions, and more via Lua.
-- This is now using the community fork: https://github.com/nvimtools/none-ls.nvim
---@type LazySpec
return {
  'nvimtools/none-ls.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'williamboman/mason.nvim',
  },
  config = function()
    local null_ls = require 'null-ls'
    local b = null_ls.builtins

    null_ls.setup {
      sources = {
        ----------------------
        --   Code Actions   --
        ----------------------
        b.code_actions.gomodifytags,
        -- Injects code actions for Git operations at the current cursor position (stage / preview / reset hunks, blame, etc.).
        b.code_actions.gitsigns,

        ----------------------
        --    Diagnostics   --
        ----------------------
        b.diagnostics.actionlint,
        b.diagnostics.ansiblelint,
        b.diagnostics.credo.with {
          condition = function(utils)
            -- Fast path: check for .credo.exs config file
            if utils.root_has_file { '.credo.exs' } then
              return true
            end

            -- Fallback: check if mix.exs contains credo dependency
            if utils.root_has_file { 'mix.exs' } then
              local file = io.open('mix.exs', 'r')
              if file then
                local content = file:read '*all'
                file:close()
                return content:match '{:credo,' ~= nil
              end
            end

            return false
          end,
        },
        b.diagnostics.yamllint,
        b.diagnostics.zsh,
        b.diagnostics.commitlint.with {
          condition = function(utils)
            return utils.root_has_file { 'commitlint.config.js' }
          end,
        },
      },
    }
  end,
}
