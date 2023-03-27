-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.

return {
  'mfussenegger/nvim-dap',

  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },

  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'js-debug-adapter',
      },
    }

    -- You can provide additional configuration to the handlers,
    -- see mason-nvim-dap README for more information
    require('mason-nvim-dap').setup_handlers()

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue)
    vim.keymap.set('n', '<F10>', dap.step_into)
    vim.keymap.set('n', '<F11>', dap.step_over)
    vim.keymap.set('n', '<F12>', dap.step_out)
    vim.keymap.set('n', '<leader>bp', dap.toggle_breakpoint)
    vim.keymap.set('n', '<leader>BP', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end)

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    dap.adapters.nlua = function(cb, config)
      cb { type = 'server', host = config.host or '127.0.0.1', port = config.port or 8088 }
    end

    dap.adapters.mix_task = function(cb, config)
      if config.preLaunchTask then
        vim.fn.system(config.preLaunchTask)
      end
      cb {
        type = 'executable',
        command = vim.fn.expand '~/.cache/nvim/elixir.nvim/installs/elixir-lsp/elixir-ls/tags_v0.13.0/1.14.3-25/debugger.sh',
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
          'apps/**/test/**/test_helper.exs',
          'apps/**/test/**/*_test.exs',
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
