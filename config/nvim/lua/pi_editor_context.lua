local M = {}

local uv = vim.uv or vim.loop
local debounce_ms = 150
local timer
local last_key
local held_visual
local visual_entry
local pending_visual
local context_file
local write_in_flight = false
local pending_write
local write_sequence = 0

local function enabled()
  return vim.env.HERDR_ENV == '1' and vim.env.HERDR_TAB_ID ~= nil and vim.env.HERDR_TAB_ID ~= ''
end

local function is_visual(mode)
  local first = mode and mode:sub(1, 1)
  return first == 'v' or first == 'V' or first == '\22'
end

local function cache_root()
  if vim.env.XDG_CACHE_HOME and vim.env.XDG_CACHE_HOME ~= '' then
    return vim.env.XDG_CACHE_HOME
  end
  return vim.env.HOME .. '/.cache'
end

local function finish_write()
  write_in_flight = false
  if pending_write ~= nil then
    vim.schedule(function()
      M._drain_write()
    end)
  end
end

local function write_all(fd, content, offset, done)
  if offset >= #content then
    done()
    return
  end

  uv.fs_write(fd, content:sub(offset + 1), offset, function(error, written)
    if error or not written or written <= 0 then
      done(error or 'short write')
      return
    end
    write_all(fd, content, offset + written, done)
  end)
end

function M._drain_write()
  if write_in_flight or pending_write == nil then
    return
  end

  local content = pending_write
  pending_write = nil
  write_in_flight = true

  if content == false then
    uv.fs_unlink(context_file, function()
      finish_write()
    end)
    return
  end

  write_sequence = write_sequence + 1
  local temporary = ('%s.tmp.%d.%d'):format(context_file, vim.fn.getpid(), write_sequence)
  uv.fs_open(temporary, 'w', tonumber('600', 8), function(open_error, fd)
    if open_error or not fd then
      finish_write()
      return
    end

    write_all(fd, content, 0, function(write_error)
      uv.fs_close(fd, function()
        if write_error then
          uv.fs_unlink(temporary, finish_write)
          return
        end
        uv.fs_rename(temporary, context_file, function()
          finish_write()
        end)
      end)
    end)
  end)
end

local function enqueue_write(content)
  pending_write = content
  M._drain_write()
end

local function selection_key(selection)
  if not selection then
    return ''
  end

  local range = selection.selection
  return table.concat({
    selection.filePath,
    range.start.line,
    range.start.character,
    range['end'].line,
    range['end'].character,
    selection.text,
  }, '\0')
end

local function publish(selection)
  local key = selection_key(selection)
  if key == last_key then
    return
  end
  last_key = key

  if not selection then
    enqueue_write(false)
    return
  end

  enqueue_write(vim.json.encode {
    version = 1,
    herdrTabId = vim.env.HERDR_TAB_ID,
    nvimPaneId = vim.env.HERDR_PANE_ID,
    pid = vim.fn.getpid(),
    updatedAt = os.time(),
    selection = selection,
  })
end

local function ordered_coordinates(first, second)
  if first.lnum < second.lnum or (first.lnum == second.lnum and first.col <= second.col) then
    return first, second
  end
  return second, first
end

local function range_selection(bufnr, mode, first, second)
  local start_pos, end_pos = ordered_coordinates(first, second)
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_pos.lnum - 1, end_pos.lnum, false)
  if #lines == 0 then
    return
  end

  local text
  if mode == 'V' then
    start_pos.col = 1
    end_pos.col = #lines[#lines] + 1
    text = table.concat(lines, '\n')
  else
    end_pos.col = math.min(end_pos.col, #lines[#lines] + 1)
    if #lines == 1 then
      text = lines[1]:sub(start_pos.col, end_pos.col)
    else
      local selected = { lines[1]:sub(start_pos.col) }
      for index = 2, #lines - 1 do
        table.insert(selected, lines[index])
      end
      table.insert(selected, lines[#lines]:sub(1, end_pos.col))
      text = table.concat(selected, '\n')
    end
  end

  return {
    text = text,
    filePath = vim.api.nvim_buf_get_name(bufnr),
    selection = {
      start = { line = start_pos.lnum - 1, character = start_pos.col - 1 },
      ['end'] = { line = end_pos.lnum - 1, character = mode == 'V' and end_pos.col - 1 or end_pos.col },
      isEmpty = text == '',
    },
  }
end

local function live_visual_selection(bufnr, mode)
  local anchor = vim.fn.getpos 'v'
  local cursor = vim.api.nvim_win_get_cursor(0)
  if anchor[2] == 0 then
    return
  end
  return range_selection(bufnr, mode, { lnum = anchor[2], col = anchor[3] }, { lnum = cursor[1], col = cursor[2] + 1 })
end

local function completed_visual_selection(bufnr, mode)
  local first = vim.fn.getpos "'<"
  local second = vim.fn.getpos "'>"
  if first[2] == 0 or second[2] == 0 then
    return
  end
  return range_selection(bufnr, mode, { lnum = first[2], col = first[3] }, { lnum = second[2], col = second[3] })
end

local function cursor_selection(bufnr)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local file_path = vim.api.nvim_buf_get_name(bufnr)
  if file_path == '' then
    return
  end

  return {
    text = '',
    filePath = file_path,
    selection = {
      start = { line = cursor[1] - 1, character = cursor[2] },
      ['end'] = { line = cursor[1] - 1, character = cursor[2] },
      isEmpty = true,
    },
  }
end

local function capture()
  if not enabled() then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local file_path = vim.api.nvim_buf_get_name(bufnr)
  if file_path == '' then
    held_visual = nil
    pending_visual = nil
    publish(nil)
    return
  end

  local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
  if is_visual(mode) then
    local selection = live_visual_selection(bufnr, mode)
    if selection then
      held_visual = {
        bufnr = bufnr,
        cursor = vim.api.nvim_win_get_cursor(0),
        selection = selection,
      }
      publish(selection)
    end
    return
  end

  if pending_visual and pending_visual.bufnr == bufnr then
    local pending = pending_visual
    pending_visual = nil
    local selection = completed_visual_selection(bufnr, pending.mode)
    if selection then
      held_visual = {
        bufnr = bufnr,
        cursor = vim.api.nvim_win_get_cursor(0),
        selection = selection,
      }
      publish(selection)
      return
    end
  end

  if held_visual and held_visual.bufnr == bufnr then
    local cursor = vim.api.nvim_win_get_cursor(0)
    if cursor[1] == held_visual.cursor[1] and cursor[2] == held_visual.cursor[2] then
      publish(held_visual.selection)
      return
    end
  end

  held_visual = nil
  publish(cursor_selection(bufnr))
end

local function schedule_capture(delay)
  if not timer then
    timer = assert(uv.new_timer())
  end
  timer:stop()
  timer:start(delay or debounce_ms, 0, vim.schedule_wrap(capture))
end

local function remove_owned_context()
  local file = io.open(context_file, 'r')
  if not file then
    return
  end
  local content = file:read '*a'
  file:close()
  local ok, payload = pcall(vim.json.decode, content)
  if ok and payload.pid == vim.fn.getpid() then
    pcall(uv.fs_unlink, context_file)
  end
end

function M.apply()
  if not enabled() or M._applied then
    return
  end
  M._applied = true

  local tab_id = vim.env.HERDR_TAB_ID:gsub('[^%w_.-]', '_')
  local directory = cache_root() .. '/pi/editor-context'
  context_file = directory .. '/' .. tab_id .. '.json'
  vim.fn.mkdir(directory, 'p', tonumber('700', 8))
  pcall(uv.fs_chmod, directory, tonumber('700', 8))

  local group = vim.api.nvim_create_augroup('PiEditorContext', { clear = true })
  vim.api.nvim_create_autocmd(
    { 'CursorMoved', 'CursorMovedI', 'BufEnter', 'WinEnter', 'TextChanged', 'TextChangedI' },
    {
      group = group,
      callback = function()
        schedule_capture()
      end,
      desc = 'Debounce Pi editor context updates',
    }
  )
  vim.api.nvim_create_autocmd('ModeChanged', {
    group = group,
    callback = function()
      local event = vim.v.event or {}
      local old_mode = event.old_mode and event.old_mode:sub(1, 1)
      local new_mode = event.new_mode and event.new_mode:sub(1, 1)
      if not is_visual(old_mode) and is_visual(new_mode) then
        visual_entry = {
          bufnr = vim.api.nvim_get_current_buf(),
          changedtick = vim.api.nvim_buf_get_changedtick(0),
        }
      elseif is_visual(old_mode) and not is_visual(new_mode) then
        local bufnr = vim.api.nvim_get_current_buf()
        if
          visual_entry
          and visual_entry.bufnr == bufnr
          and visual_entry.changedtick == vim.api.nvim_buf_get_changedtick(0)
        then
          pending_visual = { bufnr = bufnr, mode = old_mode }
        end
        visual_entry = nil
      end
      schedule_capture()
    end,
    desc = 'Track Pi visual selection context',
  })
  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = group,
    callback = function()
      if timer then
        timer:stop()
        timer:close()
        timer = nil
      end
      remove_owned_context()
    end,
    desc = 'Remove Pi editor context',
  })

  schedule_capture(0)
end

return M
