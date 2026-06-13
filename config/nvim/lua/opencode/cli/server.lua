local Server = require 'opencode.server'

local M = {}

---@param port integer|string
---@return string
local function url_for_port(port)
  return 'http://localhost:' .. tostring(port)
end

---@param url string
---@return integer?
local function port_for_url(url)
  return tonumber(url:match ':(%d+)/?$')
end

---@param server table
---@return opencode.server.Server
local function normalize(server)
  if type(server) ~= 'table' then
    return server
  end

  if server.url == nil and server.port ~= nil then
    server.url = url_for_port(server.port)
  end

  if server.port == nil and type(server.url) == 'string' then
    server.port = port_for_url(server.url)
  end

  local mt = getmetatable(server)
  if mt == Server or mt == nil then
    setmetatable(server, Server)
  end

  return server
end

local events = require 'opencode.events'
if not events._opencode_cli_compat_patched then
  ---@param server opencode.server.Server|table
  events.connect = function(server)
    local normalized = normalize(server)
    return normalized:connect()
  end

  setmetatable(events, {
    __index = function(_, key)
      if key == 'connected_server' then
        return Server.connected
      end
    end,
    __newindex = function(_, key, value)
      if key == 'connected_server' then
        Server.connected = value
      else
        rawset(events, key, value)
      end
    end,
  })

  events._opencode_cli_compat_patched = true
end

---@param port number
---@return Promise<opencode.server.Server>
function M.new(port)
  return Server.new(url_for_port(port)):next(normalize)
end

---@return Promise<opencode.server.Server[]>
function M.get_all()
  return require('opencode.server.discovery').locally():next(function(servers)
    return vim.tbl_map(normalize, servers)
  end)
end

---@param launch boolean?
---@return Promise<opencode.server.Server>
function M.get(launch)
  if launch == false then
    return require('opencode.server.discovery').locally():next(function(servers)
      return normalize(servers[1])
    end)
  end

  return require('opencode.server.discovery').get():next(normalize)
end

M.normalize = normalize
M.url_for_port = url_for_port

return M
