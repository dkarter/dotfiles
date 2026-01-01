local M = {}

local state = ya.sync(function()
  return cx.active.current.cwd
end)

function M:entry()
  ya.emit('escape', { visual = true })

  local cwd = state()
  if cwd.scheme.is_virtual then
    return ya.notify {
      title = 'TV Zoxide',
      content = 'Not supported under virtual filesystems',
      timeout = 5,
      level = 'warn',
    }
  end

  local _permit = ui.hide()
  local output, err = M.run_tv_zoxide()
  if not output then
    return ya.notify {
      title = 'TV Zoxide',
      content = tostring(err),
      timeout = 5,
      level = 'error',
    }
  end

  -- Get the selected directory from tv output
  local dir = output:match '^[^\r\n]+'
  if dir and dir ~= '' then
    local url = Url(dir)
    if url.is_absolute then
      ya.emit('cd', { url, raw = true })
    else
      ya.emit('cd', { cwd:join(url), raw = true })
    end
  end
end

function M.run_tv_zoxide()
  local child, err =
    Command('tv'):arg('zoxide'):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

  if not child then
    return nil, Err('Failed to start `tv`, error: %s', err)
  end

  local output, err = child:wait_with_output()
  if not output then
    return nil, Err('Cannot read `tv` output, error: %s', err)
  elseif not output.status.success and output.status.code ~= 130 then
    return nil, Err('`tv` exited with error code %s', output.status.code)
  end
  return output.stdout, nil
end

return M
