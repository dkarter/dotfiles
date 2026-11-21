-- Herdr shortcuts.
rex.bind('ctrl+z>shift+x', 'session.close')
rex.bind('ctrl+z>shift+w', 'session.switch')
rex.bind('ctrl+z>right', 'client.tab.next')
rex.bind('ctrl+]', 'session.next')
rex.bind('ctrl+z>left', 'client.tab.previous')
rex.bind('ctrl+[', 'session.previous')
rex.bind('ctrl+z>shift+r', 'client.config.reload')
rex.bind('ctrl+z>shift+,', 'pane.rename')
rex.bind('ctrl+z>,', 'client.tab.rename')
rex.bind('ctrl+z>r', 'session.rename')
rex.bind('ctrl+z>-', 'pane.split', { direction = 'down' })
rex.bind('ctrl+z>\\', 'pane.split', { direction = 'right' })
rex.bind('ctrl+z>1', 'client.tab.goto', { index = 1 })
rex.bind('ctrl+z>2', 'client.tab.goto', { index = 2 })
rex.bind('ctrl+z>3', 'client.tab.goto', { index = 3 })
rex.bind('ctrl+z>4', 'client.tab.goto', { index = 4 })
rex.bind('ctrl+z>5', 'client.tab.goto', { index = 5 })
rex.bind('ctrl+z>6', 'client.tab.goto', { index = 6 })
rex.bind('ctrl+z>7', 'client.tab.goto', { index = 7 })
rex.bind('ctrl+z>8', 'client.tab.goto', { index = 8 })
rex.bind('ctrl+z>9', 'client.tab.goto', { index = 9 })

-- Press the prefix twice to send Ctrl+Z to the terminal.
rex.bind('ctrl+z>ctrl+z', 'pane.send_key', { key = 'ctrl+z' })

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
end

rex.bind('ctrl+cmd+s', 'client.sidebar.toggle')
rex.bind('cmd+j', 'session.switch')
