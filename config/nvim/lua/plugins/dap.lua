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
    'theHamsta/nvim-dap-virtual-text',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    {
      'jay-babu/mason-nvim-dap.nvim',
      opts = {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_setup = true,

        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          'js-debug-adapter',
        },
      },
    },

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    vim.fn.sign_define(
      'DapBreakpoint',
      { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
    )
    vim.fn.sign_define(
      'DapBreakpointCondition',
      { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
    )
    vim.fn.sign_define(
      'DapBreakpointRejected',
      { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
    )
    vim.fn.sign_define(
      'DapLogPoint',
      { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' }
    )
    vim.fn.sign_define(
      'DapStopped',
      { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' }
    )

    -- automatically open DAP UI
    dap.listeners.before.attach.dapui_config = dapui.open
    dap.listeners.before.launch.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close

    dap.adapters.nlua = function(cb, config)
      cb { type = 'server', host = config.host or '127.0.0.1', port = config.port or 8088 }
    end

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

    dap.adapters.node2 = function(cb, config)
      if config.preLaunchTask then
        vim.fn.system(config.preLaunchTask)
      end
      cb {
        type = 'executable',
        command = 'node',
        args = {
          -- os.getenv("HOME") .. "/build/vscode-node-debug2/out/src/nodeDebug.js",
          vim.fn.stdpath 'data' .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js',
        },
      }
    end

    dap.adapters.reactnative = function(cb, config)
      if config.preLaunchTask then
        vim.fn.system(config.preLaunchTask)
      end

      cb {
        type = 'executable',
        command = 'node',
        args = {
          vim.fn.stdpath 'data' .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js',
        },
      }
    end

    dap.configurations.lua = {
      {
        type = 'nlua',
        request = 'attach',
        name = 'Attach to running Neovim instance',
        host = function()
          local value = vim.fn.input 'Host [default: 127.0.0.1]: '
          return value ~= '' and value or '127.0.0.1'
        end,
        port = function()
          local val = tonumber(vim.fn.input 'Port: ')
          assert(val, 'Please provide a port number')
          return val
        end,
      },
    }

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
          name = 'Debug Jest Tests',
          -- trace = true, -- include debugger info
          runtimeExecutable = 'node',
          runtimeArgs = {
            './node_modules/jest/bin/jest.js',
            '--runInBand',
          },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          console = 'integratedTerminal',
          internalConsoleOptions = 'neverOpen',
        },
      }
    end
  end,
}
