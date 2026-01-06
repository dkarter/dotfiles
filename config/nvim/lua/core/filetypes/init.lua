local utils = require 'core.filetypes.utils'

vim.filetype.add {
  filename = {
    ['.envrc'] = 'bash',
    ['.eslintrc'] = 'json',
    ['.prettierrc'] = 'json',
    ['.babelrc'] = 'json',
    ['zinitrc'] = 'zsh',
    ['Chart.yaml'] = 'yaml',
    ['Chart.yml'] = 'yaml',
    ['Chart.lock'] = 'yaml',
    ['helmfile.yaml'] = 'helm',
    ['Helmfile.yaml'] = 'helm',
  },
  extension = {
    yrl = 'erlang',
    yaml = utils.yaml_detect,
    yml = utils.yaml_detect,
    plist = 'xml',
  },
}

-- Detect bun TypeScript files by shebang (e.g., bin/gbsum)
-- This needs to be set up as an autocmd to override Neovim's default filetype detection
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*',
  callback = function(args)
    -- Only check files without an extension or in bin/ directory
    local path = args.file
    if path:match '%.[^/]+$' and not path:match '/bin/' then
      return -- Has extension and not in bin/, skip
    end

    -- Check first line for bun shebang
    local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1]
    if first_line and first_line:match '^#!/usr/bin/env bun' then
      vim.bo[args.buf].filetype = 'typescript'
    end
  end,
})
