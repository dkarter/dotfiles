local M = {}

local state = ya.sync(function()
  local selected = {}
  for _, url in pairs(cx.active.selected) do
    selected[#selected + 1] = url
  end
  return cx.active.current.cwd, selected
end)

function M:entry()
  ya.emit('escape', { visual = true })

  local cwd, selected = state()
  if cwd.scheme.is_virtual then
    return ya.notify {
      title = 'TV',
      content = 'Not supported under virtual filesystems',
      timeout = 5,
      level = 'warn',
    }
  end

  local _permit = ui.hide()
  local output, err = M.run_with(cwd, selected)
  if not output then
    return ya.notify {
      title = 'TV',
      content = tostring(err),
      timeout = 5,
      level = 'error',
    }
  end

  local urls = M.split_urls(cwd, output)
  if #urls == 1 then
    local cha = #selected == 0 and fs.cha(urls[1])
    ya.emit(cha and cha.is_dir and 'cd' or 'reveal', { urls[1], raw = true })
  elseif #urls > 1 then
    urls.state = #selected > 0 and 'off' or 'on'
    ya.emit('toggle_all', urls)
  end
end

function M.run_with(cwd, selected)
  local child, err

  if #selected > 0 then
    -- If there are selected files, use tv with source command that lists selected files
    -- Create a temporary file with selected entries
    local tmp_file = os.tmpname()
    local f = io.open(tmp_file, 'w')
    if f then
      for _, u in ipairs(selected) do
        f:write(tostring(u) .. '\n')
      end
      f:close()
    end

    child, err = Command('tv')
      :arg('--source-command')
      :arg(string.format('cat %s', tmp_file))
      :arg('--preview-command')
      :arg("bat -n --color=always '{}'")
      :cwd(tostring(cwd))
      :stdin(Command.INHERIT)
      :stdout(Command.PIPED)
      :stderr(Command.INHERIT)
      :spawn()
  else
    -- No selection, use files channel
    child, err = Command('tv')
      :arg('files')
      :cwd(tostring(cwd))
      :stdin(Command.INHERIT)
      :stdout(Command.PIPED)
      :stderr(Command.INHERIT)
      :spawn()
  end

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

function M.split_urls(cwd, output)
  local t = {}
  for line in output:gmatch '[^\r\n]+' do
    local u = Url(line)
    if u.is_absolute then
      t[#t + 1] = u
    else
      t[#t + 1] = cwd:join(u)
    end
  end
  return t
end

return M
