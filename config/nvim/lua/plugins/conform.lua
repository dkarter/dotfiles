-- Available formatters: https://github.com/stevearc/conform.nvim#formatters

-- Check if config files exists in the current working directory or any parent directory
-- Uses vim.fs.find for cross-platform compatibility and reasonable search limits
local function has_config(files)
  local config_files = vim.fs.find(files, {
    upward = true,
    type = 'file',
    stop = vim.fs.dirname(vim.fs.find({ '.git', 'package.json' }, { upward = true })[1]),
  })
  return #config_files > 0
end

local function get_with_fallback(root_files, formatters, fallback)
  if has_config(root_files) then
    return formatters
  else
    return fallback or {}
  end
end

-- Use biome if config exists, otherwise use the provided fallback formatter
local function get_biome_or_fallback(fallback)
  return get_with_fallback({ 'biome.json', 'biome.jsonc' }, { 'biome', 'biome-check' }, fallback)
end

-- try dprint first, then fallback to prettier
local dprint_or_prettier = get_with_fallback(
  { 'dprint.json' },
  { 'dprint' },
  { 'prettierd', 'prettier', stop_after_first = true }
)

-- Compute formatters at setup time
local js_formatters = get_biome_or_fallback(dprint_or_prettier)
local json_formatters = get_biome_or_fallback(dprint_or_prettier)
local css_formatters = get_biome_or_fallback(dprint_or_prettier)
local graphql_formatters = get_biome_or_fallback(dprint_or_prettier)

---@type LazySpec
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo', 'Format', 'FormatDisable', 'FormatEnable' },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = js_formatters,
      javascriptreact = js_formatters,
      typescript = js_formatters,
      typescriptreact = js_formatters,
      json = json_formatters,
      jsonc = json_formatters,
      css = css_formatters,
      vue = js_formatters,
      svelte = js_formatters,
      astro = js_formatters,
      graphql = graphql_formatters,
      markdown = dprint_or_prettier,
      html = dprint_or_prettier,
      go = { 'gofmt', 'goimports' },
      ruby = { 'rubyfmt' },
      sql = { 'pg_format' },
      yaml = dprint_or_prettier,
      -- mix format is taking long to format, so I bumped the timeout, I'm not
      -- sure why it's taking long though (is it large files, is it all files,
      -- is it the warm up time - maybe I can build a mix_format_d to prevent
      -- the need for warm up). Actually it could be elixir-styler that we use
      -- at PDQ is slow AF - can disable it momentarily and see if this improves
      elixir = { 'mix', timeout_ms = 2000 },
      sh = { 'shfmt' },
      zsh = { 'shfmt' },
      terraform = { 'terraform_fmt' },
      toml = { 'dprint', 'taplo', stop_after_first = true },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = 'fallback',
      timeout_ms = 1000,
    },
    -- Set up format-on-save
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      return {}
    end,
    -- Customize formatters
    formatters = {
      shfmt = {
        prepend_args = { '-i', '2' },
      },
      mix = {
        -- NOTE: conform was running mix format from the current directory of
        -- the file, which prevented formatting from working in cases where
        -- there is a nested .formatter.exs file that refers to a dependency a
        -- few folders above. For example in Phoenix projects, the
        -- .formatter.exs is created in the priv/repo/migrations dir and it
        -- references :ecto_sql, which can not be found if mix format is run
        -- directly from the migrations dir
        cwd = function(self, ctx)
          (require('conform.util').root_file { 'mix.exs' })(self, ctx)
        end,
      },
    },
  },
  config = function(_self, opts)
    local conform = require 'conform'

    conform.setup(opts)

    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = 'Disable autoformat-on-save',
      bang = true,
    })

    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = 'Re-enable autoformat-on-save',
    })

    vim.api.nvim_create_user_command('Format', function()
      conform.format { async = true }
    end, {
      desc = 'Format file',
    })
  end,
}
