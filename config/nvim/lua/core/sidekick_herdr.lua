local M = {}

-- Sidekick tools that Herdr can start and wait for via `agent start`.
local launchable = { 'claude', 'codex', 'copilot', 'cursor', 'gemini', 'grok', 'opencode', 'pi', 'qwen' }
local selected = {}
local starting = {}

local function notify(message)
  vim.notify(message, vim.log.levels.WARN, { title = 'Sidekick · Herdr' })
end

local function decode(payload)
  local ok, response = pcall(vim.json.decode, payload)
  return ok and type(response) == 'table' and response or {}
end

local function herdr(args, callback, timeout)
  local cmd = vim.list_extend({ vim.env.HERDR_BIN_PATH or 'herdr' }, args)
  local ok, err = pcall(
    vim.system,
    cmd,
    { text = true, timeout = timeout or 5000 },
    vim.schedule_wrap(function(output)
      local response = decode(output.code == 0 and output.stdout or output.stderr)
      if output.code == 0 and response.result then
        callback(response.result)
        return
      end

      local message = (response.error or {}).message or vim.trim(output.stderr or '')
      if message == '' then
        message = 'Herdr did not return a result (exit ' .. output.code .. ')'
      end
      notify(table.concat(vim.list_slice(args, 1, 2), ' ') .. ': ' .. message)
      callback(nil)
    end)
  )
  if not ok then
    notify('Could not run Herdr: ' .. err)
    callback(nil)
  end
end

local function send_draft(pane, text, callback)
  -- Herdr's CLI can submit text or send raw bytes. The socket API can paste
  -- without Enter, including when the draft contains more than one line.
  local channel, pending
  local function finish(err)
    if not channel then
      return
    end
    vim.fn.chanclose(channel)
    channel = nil
    if err then
      notify('Could not paste draft: ' .. err)
    else
      callback()
    end
  end

  local ok, id = pcall(vim.fn.sockconnect, 'pipe', vim.env.HERDR_SOCKET_PATH or '', {
    on_data = function(_, data)
      pending = (pending or '') .. table.concat(data, '\n')
      local line = pending:match '^(.-)\n'
      if line then
        local response = decode(line)
        finish(not response.result and ((response.error or {}).message or 'invalid Herdr response') or nil)
      elseif #data == 1 and data[1] == '' then
        finish 'Herdr closed the connection'
      end
    end,
  })
  if not ok or id == 0 then
    notify 'Could not connect to Herdr to paste the draft'
    return
  end
  channel = id
  local request = vim.json.encode {
    id = 'nvim:sidekick:paste',
    method = 'pane.send_input',
    params = { pane_id = pane, text = text },
  }
  local sent, count = pcall(vim.fn.chansend, channel, request .. '\n')
  if not sent or count == 0 then
    finish 'could not write to the Herdr socket'
    return
  end
  vim.defer_fn(function()
    finish 'Herdr did not respond'
  end, 5000)
end

local function start_agent(current, kind, cwd, callback)
  local tab = current.tab_id
  starting[tab] = true
  local direction = vim.o.columns >= 2 * vim.o.lines and 'right' or 'down'
  herdr({ 'pane', 'split', current.pane_id, '--direction', direction, '--cwd', cwd, '--no-focus' }, function(split)
    if not split then
      starting[tab] = nil
      return
    end

    local pane = split.pane.pane_id
    local name = 'sidekick-' .. pane:lower():gsub(':', '-')
    herdr({ 'agent', 'start', name, '--kind', kind, '--pane', pane }, function(result)
      starting[tab] = nil
      if result then
        callback(result.agent)
      end
    end, 35000)
  end)
end

local function current_agents(callback)
  local current, agents
  local function ready()
    if current and agents then
      callback(current, agents)
    end
  end
  herdr({ 'pane', 'current', '--current' }, function(result)
    current = result and result.pane
    ready()
  end)
  herdr({ 'agent', 'list' }, function(result)
    agents = result and result.agents
    ready()
  end)
end

local function with_agent(opts, pick, callback, target)
  local name = opts.name or (opts.filter or {}).name
  local cwd = vim.fn.getcwd(0)
  -- Resolve the live tab from the editor pane; inherited IDs can be stale after a pane move.
  current_agents(function(current, live)
    local tab = current.tab_id
    if target and target.tab_id ~= tab then
      notify 'The editor moved to a different Herdr tab; try again'
      return
    end
    if starting[tab] then
      notify 'An agent is already starting in this tab'
      return
    end

    local agents, kinds = {}, {}
    local pane = target and target.pane_id
    local preferred = pane or (not pick and selected[tab])
    local function use(agent)
      selected[tab] = agent.pane_id
      callback(agent)
    end

    for _, agent in ipairs(live) do
      local sibling = agent.tab_id == tab and agent.pane_id ~= current.pane_id
      if type(agent.agent) == 'string' and sibling and (not name or name == agent.agent) then
        if agent.pane_id == preferred then
          use(agent)
          return
        end
        agents[#agents + 1] = agent
        kinds[agent.agent] = true
      end
    end

    if pane then
      notify 'The selected agent is no longer in this Herdr tab'
      return
    end

    if pick or #agents == 0 then
      for _, kind in ipairs(launchable) do
        if not kinds[kind] and (not name or name == kind) then
          local tool = require('sidekick.config').get_tool(kind)
          if tool.cmd and vim.fn.executable(tool.cmd[1]) == 1 then
            agents[#agents + 1] = { agent = kind }
          end
        end
      end
    end

    if #agents == 0 then
      notify(name and ('No Herdr agent available for ' .. name) or 'No supported Herdr agents are installed')
    elseif #agents == 1 and not pick then
      local agent = agents[1]
      if agent.pane_id then
        use(agent)
      else
        start_agent(current, agent.agent, (target and target.cwd) or cwd, use)
      end
    else
      vim.ui.select(agents, {
        prompt = 'Sidekick: Herdr agent',
        format_item = function(agent)
          if not agent.pane_id then
            return 'Start ' .. agent.agent
          end
          return ('%s (%s%s)'):format(
            agent.name or agent.agent,
            agent.pane_id,
            agent.agent_status and ', ' .. agent.agent_status or ''
          )
        end,
      }, function(choice)
        if choice then
          -- Refresh the list after the picker, including before launching a new pane.
          with_agent({ name = choice.agent }, false, callback, {
            pane_id = choice.pane_id,
            tab_id = tab,
            cwd = cwd,
          })
        end
      end)
    end
  end)
end

local function focus(agent)
  herdr({ 'agent', 'focus', agent.pane_id }, function() end)
end

local function show(opts, pick)
  opts = type(opts) == 'string' and { name = opts } or opts or {}
  with_agent(opts, pick, function(agent)
    if opts.focus ~= false then
      focus(agent)
    end
  end)
end

function M.setup()
  -- Route both the Sidekick mappings and :Sidekick cli commands through Herdr.
  -- Keep Sidekick's prompt picker, context rendering and next-edit suggestions.
  local cli = require 'sidekick.cli'
  cli.show = show
  cli.toggle = show
  cli.focus = show
  cli.select = function(opts)
    show(opts, true)
  end
  cli.hide = function()
    notify 'Sidekick does not hide Herdr panes; use Herdr to manage the layout'
  end
  cli.close = function()
    herdr({ 'pane', 'current', '--current' }, function(result)
      if result then
        selected[result.pane.tab_id] = nil
      end
    end)
  end
  cli.send = function(opts)
    opts = type(opts) == 'string' and { msg = opts } or opts or {}
    local util = require 'sidekick.util'
    local text = opts.text
    if not text then
      if not opts.msg and not opts.prompt and util.visual_mode() then
        opts.msg = '{selection}'
      end
      local msg
      msg, text = cli.render(opts)
      if msg == '' or not text then
        notify 'Nothing to send'
        return
      end
    end
    util.exit_visual_mode()

    with_agent(opts, false, function(agent)
      if agent.agent_status == 'blocked' then
        notify('The agent is waiting for input in Herdr pane ' .. agent.pane_id)
        return
      end
      local msg = require('sidekick.config').get_tool(agent.agent):format(text)
      local function on_sent()
        if opts.focus then
          focus(agent)
        end
      end

      if opts.submit then
        herdr({ 'agent', 'prompt', agent.pane_id, msg }, function(result)
          if result then
            on_sent()
          end
        end)
      else
        send_draft(agent.pane_id, msg, on_sent)
      end
    end)
  end
end

return M
