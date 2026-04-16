local CompatServer = require 'opencode.cli.server'
local Server = require 'opencode.server'

local M = {}

---@param port number
---@return opencode.server.Server
local function from_port(port)
  return CompatServer.normalize(setmetatable({ port = port }, Server))
end

---@param port number
---@param on_success? fun(response: opencode.server.Event)
---@param on_error? fun(code: number, msg: string?)
---@return number job_id
function M.sse_subscribe(port, on_success, on_error)
  return from_port(port):sse_subscribe(on_success, on_error)
end

---@param port number
---@param on_success fun(response: opencode.server.PathResponse)
---@param on_error fun()
---@return number job_id
function M.get_path(port, on_success, on_error)
  return from_port(port):get_path(on_success, on_error)
end

---@param port number
---@param callback fun(agents: opencode.server.Agent[])
---@return number job_id
function M.get_agents(port, callback)
  return from_port(port):get_agents(callback)
end

---@param port number
---@param callback fun(sessions: opencode.server.Session[])
---@return number job_id
function M.get_sessions(port, callback)
  return from_port(port):get_sessions(callback)
end

---@param port number
---@param callback fun(statuses: opencode.server.SessionStatus[])
---@return number job_id
function M.get_sessions_status(port, callback)
  return from_port(port):get_sessions_status(callback)
end

---@param port number
---@param callback fun(commands: opencode.server.Command[])
---@return number job_id
function M.get_commands(port, callback)
  return from_port(port):get_commands(callback)
end

---@param port number
---@param session_id string
---@return number job_id
function M.select_session(port, session_id)
  return from_port(port):select_session(session_id)
end

return M
