--- ultra fast completion plugin with a native rust core
---@type LazySpec
return {
  'saghen/blink.cmp',
  -- this is not ready for production yet, it's mostly there, but there are
  -- some rough edges that should be resolved before enabling:
  -- - accepting the completion should work as it is with cmp today, tab
  --   inserts it and cycles options, and enter accepts (with no new line)
  enabled = true,
  event = { 'CmdlineEnter', 'InsertEnter' },
  -- optional: provides snippets for the snippet source
  dependencies = {
    'rafamadriz/friendly-snippets',
    {
      'saghen/blink.compat',
      version = '*',
      lazy = true,
      opts = {},
    },
    'mgalliou/blink-cmp-tmux',
  },

  -- use a release tag to download pre-built binaries
  version = '1.*',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = 'super-tab',
      ['<C-Z>'] = { 'accept', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = {
        'select_next',
        'snippet_forward',
        function(cmp)
          if require('core.utils').has_words_before() or vim.api.nvim_get_mode().mode == 'c' then
            return cmp.show()
          end
        end,
        'fallback',
      },
      ['<S-Tab>'] = {
        'select_prev',
        'snippet_backward',
        function(cmp)
          if vim.api.nvim_get_mode().mode == 'c' then
            return cmp.show()
          end
        end,
        'fallback',
      },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    cmdline = {
      keymap = {
        -- recommended, as the default keymap will only show and select the next item
        ['<Tab>'] = { 'show', 'accept' },
      },
      completion = {
        menu = {
          draw = {
            columns = {
              { 'kind_icon', 'label', gap = 1 },
              { 'label_description' },
            },
          },
        },
      },
    },
    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
      menu = {
        auto_show = true,
        border = 'rounded',
        draw = {
          components = {
            label = {
              text = function(ctx)
                -- Fix for weird rendering in ElixirLS structs/behaviours etc
                -- structs, behaviours and others have a label_detail emitted
                -- by ElixirLS, and it looks bad when there's no space between
                -- the module label and the label_detail.
                --
                -- The label_detail has no space because it is normally meant
                -- for function signatures, e.g. `my_function(arg1, arg2)` -
                -- this case the label is `my_function` and the label_detail
                -- is `(arg1, arg2)`.
                --
                -- In an ideal world ElixirLS would not emit them for these
                -- types - these belong in `kind` only.
                if ctx.item.client_name == 'elixirls' and ctx.kind ~= 'Function' and ctx.kind ~= 'Macro' then
                  return ctx.label
                end

                return ctx.label .. ctx.label_detail
              end,
            },
          },
          treesitter = { 'lsp' },
          columns = {
            { 'kind_icon', 'label', gap = 1 },
            { 'label_description', gap = 1 },
            { 'source_name' },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 100,
        window = {
          -- for each of the possible menu window directions,
          -- falling back to the next direction when there's not enough space
          direction_priority = {
            menu_north = { 'e', 'w', 'n', 's' },
            menu_south = { 'e', 'w', 's', 'n' },
          },
        },
      },
    },
    signature = { enabled = true },
    -- ghost_text = { enabled = true },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'tmux' },
      providers = {
        tmux = {
          enabled = function()
            return os.getenv 'TMUX' ~= nil
          end,
          module = 'blink-cmp-tmux',
          name = 'tmux',
          -- default options
          opts = {
            all_panes = true,
            capture_history = true,
            -- only suggest completions from `tmux` if the `trigger_chars` are
            -- used
            triggered_only = true,
            trigger_chars = { ';' },
          },
        },
        snippets = {
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind ~= 'trigger_character'
          end,
        },
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
