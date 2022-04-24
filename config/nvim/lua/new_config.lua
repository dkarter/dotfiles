local modules = {
  "core.options",
  "core.commands",
  "core.autocmds",
  "core.mappings",
  "plugins",
}

for _, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if not ok then
    error("Error loading " .. module .. "\n\n" .. err)
  end
end
