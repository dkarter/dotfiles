-- Elixir Map Key Toggle Plugin
-- This plugin toggles Elixir map keys between atom and string syntax.
-- Mostly borrowed from https://github.com/mxgrn/dotfiles/blob/master/.config/nvim/lua/elixir_map_key_toggle.lua

-- Helper to get text from a node
local function get_node_text(node, bufnr)
  local start_row, start_col, end_row, end_col = node:range()
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)

  if #lines == 0 then
    return ''
  end

  if start_row == end_row then
    return lines[1]:sub(start_col + 1, end_col)
  else
    lines[1] = lines[1]:sub(start_col + 1)
    lines[#lines] = lines[#lines]:sub(1, end_col)
    return table.concat(lines, '\n')
  end
end

-- Helper to get direct children of a node
local function get_direct_children(node)
  local children = {}
  for child in node:iter_children() do
    table.insert(children, child)
  end
  return children
end

-- Replace node text in buffer
local function replace_node(bufnr, node, new_text)
  local start_row, start_col, end_row, end_col = node:range()

  if start_row == end_row then
    local line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
    local before = line:sub(1, start_col)
    local after = line:sub(end_col + 1)
    vim.api.nvim_buf_set_lines(bufnr, start_row, start_row + 1, false, { before .. new_text .. after })
  else
    local new_lines = vim.split(new_text, '\n', { plain = true })
    local first_line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
    local last_line = vim.api.nvim_buf_get_lines(bufnr, end_row, end_row + 1, false)[1]

    new_lines[1] = first_line:sub(1, start_col) .. new_lines[1]
    new_lines[#new_lines] = new_lines[#new_lines] .. last_line:sub(end_col + 1)

    vim.api.nvim_buf_set_lines(bufnr, start_row, end_row + 1, false, new_lines)
  end
end

-- Toggle between string ↔ atom (repeatable)
local function toggle_string_atom(bufnr, node)
  if not node then
    return false
  end

  local node_type = node:type()
  local text = get_node_text(node, bufnr)

  -- Climb up if cursor is inside quoted_content (part of a string)
  if node_type == 'quoted_content' then
    node = node:parent()
    node_type = node:type()
    text = get_node_text(node, bufnr)
  end

  -- Case 1: :foo → "foo"
  if node_type == 'atom' or text:match '^:%w+$' then
    local key = text:gsub('^:', '')
    replace_node(bufnr, node, '"' .. key .. '"')
    vim.notify('Toggled atom → string', vim.log.levels.INFO)
    pcall(vim.fn['repeat#set'], ':ElixirToggleMapKeys\r')
    return true
  end

  -- Case 2: "foo" → :foo
  if node_type == 'string' or text:match '^".+"$' then
    local inner = text:match '^"(.*)"$' or text
    if inner:match '^[%w_]+$' then
      replace_node(bufnr, node, ':' .. inner)
      vim.notify('Toggled string → atom', vim.log.levels.INFO)
      pcall(vim.fn['repeat#set'], ':ElixirToggleMapKeys\r')
      return true
    end
  end

  return false
end

-- Find all map nodes within a given node (for deep processing)
local function find_all_maps(node)
  local maps = {}

  local function traverse(n)
    if n:type() == 'map' then
      table.insert(maps, n)
    end
    for child in n:iter_children() do
      traverse(child)
    end
  end

  traverse(node)
  return maps
end

-- Toggle a single map's keys while preserving formatting
local function toggle_single_map(bufnr, map_node)
  local map_content = nil
  for child in map_node:iter_children() do
    if child:type() == 'map_content' then
      map_content = child
      break
    end
  end

  if not map_content then
    return false
  end

  local pairs = {}
  local is_keyword_syntax = false

  for child in map_content:iter_children() do
    if child:type() == 'binary_operator' then
      local op_text = get_node_text(child, bufnr)
      if op_text:match '^.-=>' then
        table.insert(pairs, child)
      end
    elseif child:type() == 'keywords' then
      is_keyword_syntax = true
      for pair_node in child:iter_children() do
        if pair_node:type() == 'pair' then
          table.insert(pairs, pair_node)
        end
      end
    end
  end

  if #pairs == 0 then
    return false
  end

  -- Process pairs in reverse order to maintain correct offsets
  for i = #pairs, 1, -1 do
    local pair = pairs[i]

    if is_keyword_syntax then
      -- keyword syntax: key: value → "key" => value
      local children = get_direct_children(pair)
      local key_node
      for _, c in ipairs(children) do
        if c:type() == 'keyword' then
          key_node = c
          break
        end
      end

      if key_node then
        local key_text = get_node_text(key_node, bufnr)
        local atom_key = key_text:gsub(':%s*$', '')
        replace_node(bufnr, key_node, '"' .. atom_key .. '" =>')
      end
    else
      -- arrow syntax: "key" => value → key: value
      local op_children = get_direct_children(pair)
      local key_node = op_children[1]

      if key_node and key_node:type() == 'string' then
        local quoted_content
        for c in key_node:iter_children() do
          if c:type() == 'quoted_content' then
            quoted_content = c
            break
          end
        end

        if quoted_content then
          local key_text = get_node_text(quoted_content, bufnr)
          -- Find and replace the key and arrow operator together
          local start_row, start_col = key_node:range()
          local _, _, end_row, end_col = pair:range()

          -- Get the value node (last child that's not a comma)
          local value_node = op_children[#op_children]
          local _, _, value_end_row, value_end_col = value_node:range()

          -- Replace from key start to just before value
          local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, value_end_row + 1, false)
          if #lines > 0 then
            local full_text = get_node_text(pair, bufnr)
            local value_text = get_node_text(value_node, bufnr)
            local new_text = full_text:gsub('^%s*"[^"]*"%s*=>%s*', key_text .. ': ')
            replace_node(bufnr, pair, new_text)
          end
        end
      end
    end
  end

  return true
end

local M = {}

-- Main toggle function
function M.toggle_elixir_map_keys(opts)
  opts = opts or {}
  local deep = opts.deep or false

  local ts = vim.treesitter
  local node = ts.get_node()
  if not node then
    vim.notify('No treesitter node found', vim.log.levels.WARN)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()

  -- Find enclosing map
  local map_node = node
  while map_node and map_node:type() ~= 'map' do
    map_node = map_node:parent()
  end

  if not map_node or map_node:type() ~= 'map' then
    -- Not inside a map → fallback to string/atom toggle
    local success = toggle_string_atom(bufnr, node)
    if not success then
      vim.notify('Not inside a map, and cursor not on atom/string', vim.log.levels.WARN)
    end
    return
  end

  -- Determine which maps to process
  local maps_to_process = {}
  if deep then
    -- Find all nested maps within the enclosing map
    maps_to_process = find_all_maps(map_node)
    -- Sort by depth (deepest first) to avoid offset issues
    table.sort(maps_to_process, function(a, b)
      local depth_a = 0
      local node_a = a
      while node_a do
        depth_a = depth_a + 1
        node_a = node_a:parent()
      end

      local depth_b = 0
      local node_b = b
      while node_b do
        depth_b = depth_b + 1
        node_b = node_b:parent()
      end

      return depth_a > depth_b
    end)
    vim.notify('Toggling ' .. #maps_to_process .. ' map(s) (deep mode)', vim.log.levels.INFO)
  else
    -- Only process the current map
    table.insert(maps_to_process, map_node)
  end

  -- Process each map
  local success_count = 0
  for _, map in ipairs(maps_to_process) do
    if toggle_single_map(bufnr, map) then
      success_count = success_count + 1
    end
  end

  if success_count == 0 then
    vim.notify('No maps were toggled', vim.log.levels.WARN)
  else
    local mode_str = deep and ' (deep)' or ''
    vim.notify('Toggled ' .. success_count .. ' map(s)' .. mode_str, vim.log.levels.INFO)
  end

  pcall(vim.fn['repeat#set'], ':ElixirToggleMapKeys\r')
end

return M
