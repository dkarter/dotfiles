local core_mappings = require 'core.mappings'

-- notifications
return {
  'rcarriga/nvim-notify',
  opts = {
    background_colour = '#000',
    render = 'compact',
  },
  config = function(_notify, opts)
    local notify = require 'notify'
    ---@diagnostic disable-next-line: undefined-field
    notify.setup(opts)
    vim.notify = notify
    core_mappings.notify_mappings()
  end,
}
