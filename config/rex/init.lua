-- Capture Ctrl+Z as a one-shot prefix instead of passing it to the terminal.
rex.mode('herdr_prefix', { exclusive = true })
rex.bind('ctrl+z', 'client.mode.enter', { name = 'herdr_prefix', once = true })
rex.bind('herdr_prefix/shift+x', 'session.close')
rex.bind('herdr_prefix/shift+w', 'session.switch')
rex.bind('herdr_prefix/right', 'client.tab.next')
rex.bind('ctrl+]', 'session.next')
rex.bind('herdr_prefix/left', 'client.tab.previous')
rex.bind('ctrl+[', 'session.previous')
rex.bind('herdr_prefix/shift+r', 'client.config.reload')
rex.bind('herdr_prefix/shift+,', 'pane.rename')
rex.bind('herdr_prefix/,', 'client.tab.rename')
rex.bind('herdr_prefix/r', 'session.rename')
rex.bind('herdr_prefix/z', 'pane.zoom')
rex.bind('herdr_prefix/-', 'pane.split', { direction = 'down' })
rex.bind('herdr_prefix/\\', 'pane.split', { direction = 'right' })
rex.bind('herdr_prefix/1', 'client.tab.goto', { index = 1 })
rex.bind('herdr_prefix/2', 'client.tab.goto', { index = 2 })
rex.bind('herdr_prefix/3', 'client.tab.goto', { index = 3 })
rex.bind('herdr_prefix/4', 'client.tab.goto', { index = 4 })
rex.bind('herdr_prefix/5', 'client.tab.goto', { index = 5 })
rex.bind('herdr_prefix/6', 'client.tab.goto', { index = 6 })
rex.bind('herdr_prefix/7', 'client.tab.goto', { index = 7 })
rex.bind('herdr_prefix/8', 'client.tab.goto', { index = 8 })
rex.bind('herdr_prefix/9', 'client.tab.goto', { index = 9 })

-- Press the prefix twice to send Ctrl+Z to the terminal.
rex.bind('herdr_prefix/ctrl+z', 'pane.send_key', { key = 'ctrl+z' })

-- Neovim moves between its own splits before handing focus back to Rex.
local navigation_keys = {
  left = 'h',
  down = 'j',
  up = 'k',
  right = 'l',
}

rex.action {
  name = 'seamless_navigate',
  title = 'Navigate Neovim or Rex Pane',
  args = { direction = 'string', from_editor = 'boolean?' },
  repeats = true,
  run = function(ctx, args)
    local key = assert(navigation_keys[args.direction], 'invalid navigation direction')
    if not args.from_editor and ctx.block_id then
      local process = rex.block.call('com.superlogical.terminal', 'process')
      local name = process and process.foreground and process.foreground.name
      if type(name) == 'string' and (name == 'nvim' or name:match '^nvim%-') then
        -- Deliver directly to the editor, without triggering this binding again.
        local _, err = rex.call('block.event', {
          session_id = ctx.session_id,
          block_id = ctx.block_id,
          event = {
            type = 'key',
            payload = {
              key = 'key_' .. key,
              mods = 'ctrl',
              consumed_mods = '',
              text = '',
              unshifted_codepoint = key:byte(),
              composing = false,
              action = 'press',
            },
          },
        })
        if err then
          error(err, 0)
        end
        return
      end
    end

    -- A delayed editor handoff must not move focus from a different pane.
    local view, err = rex.session.view()
    if not view then
      error(err, 0)
    end
    for _, window in ipairs(view.windows) do
      if window.window_id == view.active_window_id and window.focused_block_id == ctx.block_id then
        local _, focus_err = rex.session.focus_direction { direction = args.direction }
        if focus_err then
          error(focus_err, 0)
        end
        return
      end
    end
  end,
}

for direction, key in pairs(navigation_keys) do
  rex.bind('ctrl+' .. key, 'seamless_navigate', { direction = direction })
  rex.bind('alt+' .. key, 'pane.resize', { direction = direction })
end

rex.bind('ctrl+cmd+s', 'client.sidebar.toggle')
rex.bind('cmd+j', 'session.switch')
