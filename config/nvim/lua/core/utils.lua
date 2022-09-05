local M = {}

-- Load project specific vimrc
function M.load_local_vimrc()
  local cwd = vim.fn.getcwd()
  local home_dir = vim.fn.expand '~'
  local local_vimrc = vim.fn.glob(cwd .. '/.vimrc')

  if cwd ~= home_dir and vim.fn.empty(local_vimrc) == 0 then
    vim.notify '------> loading local vimrc for project'
    vim.opt.exrc = true
    vim.cmd('source ' .. local_vimrc)
  end
end

-- Returns a list of border characters
---@param name 'double' | 'none' | 'rounded' | 'shadow' | 'single'
---@return table<string>
function M.get_border_chars(name)
  local border_chars = {
    double = { '═', '║', '═', '║', '╔', '╗', '╝', '╚' },
    none = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    rounded = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    shadow = { '▀', '█', '▄', '█', '█', '█', '█', '█' },
    single = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  }

  return border_chars[name]
end

-- Reload all lua configuration modules
function M.reload_modules()
  local config_path = vim.fn.stdpath 'config' .. '/lua/'
  local lua_files = vim.fn.glob(config_path .. '**/*.lua', 0, 1)

  for _, file in ipairs(lua_files) do
    local module_name = string.gsub(file, '.*/(.*)/(.*).lua', '%1.%2')
    vim.pretty_print(module_name)
    package.loaded[module_name] = nil
  end
  vim.cmd [[source $MYVIMRC]]
  vim.notify 'Reloaded all config modules'
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

-- Reads JSON Schemas from cache location
function M.read_json_schemas()
  local catalog_path = json_schemas_catalog_path()

  if catalog_path:exists() then
    local contents = catalog_path:read()
    return vim.json.decode(contents)
  else
    return nil
  end
end

-- Reloads the current Lua file
function M.reload_current_luafile()
  local current_file = vim.fn.expand '%'
  print(current_file)
  vim.cmd(string.format('luafile %s', current_file))
  vim.notify(string.format('Reloaded %s!', current_file))
end

-- Pads a string's right hand side
---@param str string String to pad
---@param len number How many characters to pad by
---@param char string Character to use when padding
function M.right_pad(str, len, char)
  local res = str .. string.rep(char or ' ', len - #str)
  return res, res ~= str
end

-- Pads a string's left hand side
---@param str string String to pad
---@param len number How many characters to pad by
---@param char string Character to use when padding
function M.left_pad(str, len, char)
  local res = string.rep(char or ' ', len - #str) .. str
  return res, res ~= str
end

-- Checks if a table contains a value
---@param tbl table
---@param item any
---@return boolean
function M.contains(tbl, item)
  for x in pairs(tbl) do
    if x == item then
      return true
    end
  end

  return false
end

return M
