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

local M = {}

-- Main toggle function
function M.toggle_elixir_map_keys()
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

  -- otherwise continue with your map key toggle logic (unchanged)
  local map_content = nil
  for child in map_node:iter_children() do
    if child:type() == 'map_content' then
      map_content = child
      break
    end
  end

  if not map_content then
    vim.notify('Map has no content', vim.log.levels.WARN)
    return
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
    vim.notify('No key-value pairs found', vim.log.levels.WARN)
    return
  end

  if is_keyword_syntax then
    local new_pairs = {}
    for _, pair in ipairs(pairs) do
      local children = get_direct_children(pair)
      local key_node, value_node
      for _, c in ipairs(children) do
        if c:type() == 'keyword' then
          key_node = c
        elseif key_node and c:type() ~= ',' then
          value_node = c
          break
        end
      end
      if key_node and value_node then
        local key_text = get_node_text(key_node, bufnr):gsub(':%s*$', '')
        local value_text = get_node_text(value_node, bufnr)
        table.insert(new_pairs, '"' .. key_text .. '" => ' .. value_text)
      end
    end

    if #new_pairs > 0 then
      local keywords_node
      for child in map_content:iter_children() do
        if child:type() == 'keywords' then
          keywords_node = child
          break
        end
      end
      if keywords_node then
        replace_node(bufnr, keywords_node, table.concat(new_pairs, ', '))
      end
    end
    vim.notify('Toggled to string-key map', vim.log.levels.INFO)
  else
    local new_pairs = {}
    for _, binary_op in ipairs(pairs) do
      local op_children = get_direct_children(binary_op)
      local key_node = op_children[1]
      local value_node = op_children[#op_children]
      if key_node and key_node:type() == 'string' and value_node then
        local quoted_content
        for c in key_node:iter_children() do
          if c:type() == 'quoted_content' then
            quoted_content = c
            break
          end
        end
        if quoted_content then
          local key_text = get_node_text(quoted_content, bufnr)
          local value_text = get_node_text(value_node, bufnr)
          table.insert(new_pairs, key_text .. ': ' .. value_text)
        end
      end
    end

    if #new_pairs > 0 then
      replace_node(bufnr, map_content, table.concat(new_pairs, ', '))
    end
    vim.notify('Toggled to atom-key map', vim.log.levels.INFO)
  end

  pcall(vim.fn['repeat#set'], ':ElixirToggleMapKeys\r')
end

return M
