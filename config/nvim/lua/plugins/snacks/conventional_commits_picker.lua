local gen_items = function(tbl)
  local items = {}
  for k, v in pairs(tbl) do
    table.insert(items, { text = k, preview = { text = v } })
  end
  return items
end

local conventional_commits = {
  test = 'Adding missing tests or correcting existing tests',
  style = 'Changes that do not affect the meaning of the code',
  revert = 'Reverts a previous commit',
  refactor = 'A code change that neither fixes a bug nor adds a feature',
  perf = 'A code change that improves performance',
  fix = 'A bug fix',
  feat = 'A new feature',
  docs = 'Documentation only changes',
  ci = 'Changes to our CI configuration files and scripts',
  chore = "Other changes that don't modify src or test files",
  build = 'Changes that affect the build system or external dependencies',
}

---@module "snacks"
---@class snacks.picker.Config
local conventional_commits_picker_opts = {
  source = 'Conventional Commits',
  items = gen_items(conventional_commits),
  preview = 'preview',
  format = 'text',
  confirm = function(picker_window, item)
    picker_window:close()
    Snacks.input.disable()
    if not item then
      return
    end

    local new_msg = item.text
    vim.ui.input({ prompt = 'Scope? (optional - enter to skip)' }, function(scope)
      -- scope is nil if dialog is aborted
      if scope and scope ~= '' then
        new_msg = string.format('%s(%s)', new_msg, scope)
      end

      new_msg = string.format('%s: ', new_msg)
    end)

    -- update the line
    vim.api.nvim_win_set_cursor(0, { 1, 1 })
    vim.api.nvim_set_current_line(new_msg)

    -- place cursor at the end of the line in insert mode
    vim.api.nvim_feedkeys('A', 'n', true)
    Snacks.input.enable()
  end,
}

return conventional_commits_picker_opts
