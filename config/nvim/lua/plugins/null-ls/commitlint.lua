local nullls = require 'null-ls'
local h = require 'null-ls.helpers'
local methods = require 'null-ls.methods'
local DIAGNOSTICS = methods.internal.DIAGNOSTICS

local commitlint = {
  name = 'commitlint',
  meta = {
    url = '',
    description = 'Linter for Git commit messages.',
  },
  method = DIAGNOSTICS,
  filetypes = { 'gitcommit', 'NeogitCommitMessage' },
  condition = function(utils)
    return utils.root_has_file { 'commitlint.config.js' }
  end,
  generator = nullls.generator {
    command = 'commitlint',
    to_stdin = true,
    from_stderr = true,
    format = 'raw',
    on_output = function(params, done)
      local diags = {}
      if params.output == nil or params.output == '' then
        done(diags)
      end
      local splits = vim.split(params.output, '\n')
      local errors = {}
      for _index, data in ipairs(splits) do
        if string.find(data, '✖ ') then
          table.insert(errors, data)
        end
      end
      for index, data in ipairs(errors) do
        data = data:gsub('%✖ ', '')
        data = data:gsub('%  ', '')
        if index ~= #errors then
          table.insert(diags, {
            row = 1,
            col = 1,
            end_col = 1,
            message = data,
            severity = 'error',
          })
        end
      end
      done(diags)
    end,
  },
  factory = h.generator_factory,
}

return commitlint
