local M = {}

-- Load project specific vimrc
function M.load_local_vimrc()
  local cwd = vim.fn.getcwd()
  local home_dir = vim.fn.expand '~'
  local local_vimrc = vim.fn.glob(cwd .. '/.vimrc')

  if cwd ~= home_dir and vim.fn.empty(local_vimrc) == 0 then
    print '------> loading local vimrc for project'
    vim.opt.exrc = true
    vim.cmd('source ' .. local_vimrc)
  end
end

-- Reload all lua configuration modules
function M.reload_modules()
  local lua_dirs = vim.fn.glob('./lua/*', 0, 1)
  for _, dir in ipairs(lua_dirs) do
    dir = string.gsub(dir, './lua/', '')
    require('plenary.reload').reload_module(dir)
  end
end

function M.imap(tbl)
  vim.keymap.set('i', tbl[1], tbl[2], tbl[3])
end

function M.nmap(tbl)
  vim.keymap.set('n', tbl[1], tbl[2], tbl[3])
end

function M.xmap(tbl)
  vim.keymap.set('x', tbl[1], tbl[2], tbl[3])
end

function M.vmap(tbl)
  vim.keymap.set('v', tbl[1], tbl[2], tbl[3])
end

-- Builds the path for the json schema catalog cache
---@return Path path
local json_schemas_catalog_path = function()
  local Path = require 'plenary.path'
  local base_path = Path:new(vim.fn.stdpath 'data')
  return base_path:joinpath 'json_schema_catalog.json'
end

-- Fetches the JSON Schemas catalog from the SchemaStore API and stores it in a
-- local file
function M.download_json_schemas()
  local catalog_path = json_schemas_catalog_path()

  -- download the latest json schema catalog
  local json = vim.fn.system {
    'curl',
    'https://json.schemastore.org/api/json/catalog.json',
    '--silent',
  }

  -- write file
  catalog_path:write(json, 'w')

  -- notify user
  vim.notify(string.format('Wrote JSON Schemas catalog to %s', catalog_path))
end

function M.read_json_schemas()
  local catalog_path = json_schemas_catalog_path()

  if catalog_path:exists() then
    local contents = catalog_path:read()
    return vim.json.decode(contents)
  else
    return nil
  end
end

return M
