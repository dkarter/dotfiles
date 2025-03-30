-- DAP - Debug Adapter Protocol integration (like LSP for debugging)
---@type LazySpec
return {
  'mfussenegger/nvim-dap',
  keys = require('core.mappings').nvim_dap_mappings,
  dependencies = {
    -- Creates a beautiful debugger UI
    {
      'rcarriga/nvim-dap-ui',
      ---@module "dapui"
      ---@type dapui.Config
      ---@diagnostic disable-next-line: missing-fields
      opts = {
        icons = {
          expanded = '▾',
          collapsed = '▸',
          current_frame = '*',
        },
      },
      dependencies = { 'nvim-neotest/nvim-nio' },
    },
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = {
        enabled = true, -- enable this plugin (the default)
        enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true, -- show stop reason when stopped for exceptions
        commented = false, -- prefix virtual text with comment string
        only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
        all_references = false, -- show virtual text on all all references of the variable (not only definitions)
        filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
        -- Experimental Features:
        virt_text_pos = 'eol', -- position of virtual text, see `:h nvim_buf_set_extmark()`
        all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
      },
    },

    -- Installs the debug adapters for you
    {
      'jay-babu/mason-nvim-dap.nvim',
      ---@module "mason-nvim-dap"
      ---@type MasonNvimDapSettings
      opts = {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          'js-debug-adapter',
          'bash-debug-adapter',
        },
        handlers = {},
      },
      dependencies = {
        'williamboman/mason.nvim',
      },
    },

    {
      'LiadOz/nvim-dap-repl-highlights',
      opts = {},
      dependencies = {
        'dkarter/nvim-treesitter',
      },
      build = function()
        -- the dap_repl parser can only be found after the plugin has loaded
        if not require('nvim-treesitter.parsers').has_parser 'dap_repl' then
          vim.cmd ':TSInstall dap_repl'
        end
      end,
    },

    -- GO
    'leoluz/nvim-dap-go',

    -- JS/TS/React/Node
    {
      'microsoft/vscode-js-debug',
      -- After install, build it and rename the dist directory to out
      build = 'git checkout .; mise use node@20.16.0 && npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out; git checkout .',
    },
    {
      'mxsdev/nvim-dap-vscode-js',
      ---@module "dap-vscode-js"
      ---@type Settings
      opts = {
        debugger_path = vim.fn.resolve(vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug'),
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
      },
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- automatically open DAP UI
    dap.listeners.before.attach.dapui_config = dapui.open
    dap.listeners.before.launch.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close

    -----------------------------------------
    --- SETUP ADAPTERS AND CONFIGURATIONS ---
    -----------------------------------------
    -- More here: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    -----------------------------------------
    dap.adapters.mix_task = function(cb, config)
      if config.preLaunchTask then
        vim.fn.system(config.preLaunchTask)
      end
      cb {
        type = 'executable',
        -- TODO: find a way to make this less hard-coded
        command = vim.fn.expand '~/.cache/nvim/elixir-tools.nvim/installs/elixir-lsp/elixir-ls/tags_v0.22.0/1.17.2-27/debug_adapter.sh',
        args = {},
      }
    end

    dap.configurations.elixir = {
      {
        type = 'mix_task',
        name = 'mix test',
        task = 'test',
        taskArgs = { '--trace' },
        request = 'launch',
        startApps = true, -- for Phoenix projects
        projectDir = '${workspaceFolder}',
        requireFiles = {
          'test/**/test_helper.exs',
          'test/**/*_test.exs',
          -- for umbrella projects
          'apps/**/test/**/test_helper.exs',
          'apps/**/test/**/*_test.exs',
          -- for PDQ
          'lib/**/*_test.exs',
        },
      },
      {
        type = 'mix_task',
        name = 'phx.server',
        request = 'launch',
        task = 'phx.server',
        projectDir = '.',
      },
    }

    dap.adapters.bashdb = {
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
      name = 'bashdb',
    }

    dap.configurations.sh = {
      {
        type = 'bashdb',
        request = 'launch',
        name = 'Launch file',
        showDebugOutput = true,
        pathBashdb = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
        pathBashdbLib = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
        trace = true,
        file = '${file}',
        program = '${file}',
        cwd = '${workspaceFolder}',
        pathCat = 'cat',
        pathBash = vim.fn.exepath 'bash',
        pathMkfifo = 'mkfifo',
        pathPkill = 'pkill',
        args = {},
        env = {},
        terminalKind = 'integrated',
      },
    }

    for _, language in ipairs { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' } do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Jest (current file)',
          -- trace = true, -- include debugger info
          runtimeExecutable = 'node',
          runtimeArgs = {
            './node_modules/jest/bin/jest.js',
            '--runInBand',
          },
          args = { '${file}', '--coverage', 'false' },
          sourceMaps = true,
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Debug Vitest (current file)',
          cwd = '${workspaceFolder}',
          program = '${workspaceFolder}/node_modules/vitest/vitest.mjs',
          args = { '--inspect-brk', '--threads', 'false', 'run', '${file}' },
          autoAttachChildProcesses = true,
          smartStep = true,
          console = 'integratedTerminal',
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
        },
      }
    end
  end,
}
