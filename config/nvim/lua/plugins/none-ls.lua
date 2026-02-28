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
    local helpers = require 'null-ls.helpers'
    local methods = require 'null-ls.methods'
    local diagnostics = methods.internal.DIAGNOSTICS

    local committed = helpers.make_builtin {
      name = 'committed',
      method = diagnostics,
      filetypes = { 'gitcommit' },
      generator_opts = {
        command = 'committed',
        args = { '--format', 'json', '--commit-file', '-' },
        to_stdin = true,
        format = 'line',
        check_exit_code = function(code)
          return code <= 1
        end,
        on_output = function(line, _)
          local ok, item = pcall(vim.json.decode, line)
          if not ok or not item then
            return nil
          end

          local message = 'Invalid commit message'
          if type(item.content) == 'table' then
            message = item.content.error or item.content.message or item.content.type or message
          elseif type(item.content) == 'string' then
            message = item.content
          end

          local severity = vim.diagnostic.severity.ERROR
          if item.severity == 'warning' then
            severity = vim.diagnostic.severity.WARN
          elseif item.severity == 'info' then
            severity = vim.diagnostic.severity.INFO
          end

          return {
            row = 1,
            col = 1,
            end_col = 1,
            severity = severity,
            message = message,
            source = 'committed',
          }
        end,
      },
      condition = function(utils)
        return utils.root_has_file { 'committed.toml' }
      end,
    }

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
        committed,
      },
      debounce = 200,
    }
  end,
}
