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
