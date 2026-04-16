local Server = require 'opencode.server'

local M = {}

---@param server table
---@return opencode.server.Server
local function normalize(server)
  if type(server) ~= 'table' then
    return server
  end

  local mt = getmetatable(server)
  if mt == Server or mt == nil then
    setmetatable(server, Server)
  end

  return server
end

local events = require 'opencode.events'
if not events._opencode_cli_compat_patched then
  local original_connect = events.connect

  ---@param server opencode.server.Server|table
  events.connect = function(server)
    return original_connect(normalize(server))
  end

  events._opencode_cli_compat_patched = true
end

---@param port number
---@return Promise<opencode.server.Server>
function M.new(port)
  return Server.new(port):next(normalize)
end

---@return Promise<opencode.server.Server[]>
function M.get_all()
  return Server.get_all():next(function(servers)
    return vim.tbl_map(normalize, servers)
  end)
end

---@param launch boolean?
---@return Promise<opencode.server.Server>
function M.get(launch)
  return Server.get(launch):next(normalize)
end

M.normalize = normalize

return M
