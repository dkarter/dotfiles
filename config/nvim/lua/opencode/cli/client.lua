local CompatServer = require 'opencode.cli.server'
local Server = require 'opencode.server'

local M = {}

---@param port number
---@return opencode.server.Server
local function from_port(port)
  return CompatServer.normalize(setmetatable({ port = port, url = CompatServer.url_for_port(port) }, Server))
end

---@param promise Promise
---@param on_success? fun(response: any)
---@param on_error? fun(err: any)
---@return Promise
local function with_callbacks(promise, on_success, on_error)
  if on_success then
    promise = promise:next(function(response)
      on_success(response)
      return response
    end)
  end

  if on_error then
    promise = promise:catch(function(err)
      on_error(err)
      return require('opencode.promise').reject(err)
    end)
  end

  return promise
end

---@param port number
---@param path string
---@param callback? fun(response: any)
---@param on_error? fun(err: any)
---@return Promise
local function get(port, path, callback, on_error)
  return with_callbacks(
    require('opencode.promise').new(function(resolve, reject)
      from_port(port):curl(path, 'GET', nil, resolve, reject)
    end),
    callback,
    on_error
  )
end

---@param port number
---@param on_success? fun(response: opencode.server.Event)
---@param on_error? fun(code: number, msg: string?)
---@return number job_id
function M.sse_subscribe(port, on_success, on_error)
  return from_port(port):sse_subscribe(on_success, function(msg, code)
    if on_error then
      on_error(code, msg)
    end
  end)
end

---@param port number
---@param on_success fun(response: opencode.server.PathResponse)
---@param on_error fun()
---@return number job_id
function M.get_path(port, on_success, on_error)
  return with_callbacks(from_port(port):get_path(), on_success, on_error)
end

---@param port number
---@param callback fun(agents: opencode.server.Agent[])
---@return number job_id
function M.get_agents(port, callback)
  return with_callbacks(from_port(port):get_agents(), callback)
end

---@param port number
---@param callback fun(sessions: opencode.server.Session[])
---@return number job_id
function M.get_sessions(port, callback)
  return with_callbacks(from_port(port):get_sessions(), callback)
end

---@param port number
---@param callback fun(statuses: opencode.server.SessionStatus[])
---@return number job_id
function M.get_sessions_status(port, callback)
  return get(port, '/session/status', callback)
end

---@param port number
---@param callback fun(commands: opencode.server.Command[])
---@return number job_id
function M.get_commands(port, callback)
  return get(port, '/command', callback)
end

---@param port number
---@param session_id string
---@return number job_id
function M.select_session(port, session_id)
  return from_port(port):select_session(session_id)
end

return M
