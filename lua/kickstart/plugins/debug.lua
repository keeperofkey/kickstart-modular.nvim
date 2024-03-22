-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
    -- 'mxsdev/nvim-dap-vscode-js',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        -- 'js-debug-adapter',
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

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
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup()
    require('dap-python').setup '~/.virtualenvs/debugpy/bin/python'
    -- require('dap-vscode-js').setup {
    --   -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    --   -- debugger_path = '~/.local/share/nvim/lazy/vscode-js-debug/src/dapDebugServer.ts',
    --   debugger_path = '/home/d0/.local/share/nvim/lazy/vscode-js-debug',
    --   -- debugger_cmd = { 'js-debug-adapter' }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    --   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost', 'chrome' }, -- which adapters to register in nvim-dap
    --   -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
    --   -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
    --   -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
    -- }
    --
    -- for _, language in ipairs { 'typescript', 'javascript' } do
    --   require('dap').configurations[language] = {
    --     {
    --       type = 'pwa-chrome',
    --       request = 'launch',
    --       name = 'Launch with localhost',
    --       url = 'http://localhost:3000',
    --     },
    --     {
    --       type = 'chrome',
    --       request = 'launch',
    --       name = 'Launch with chrome',
    --       url = 'http://localhost:3000',
    --     },
    --     {
    --       type = 'pwa-chrome',
    --       request = 'attach',
    --       name = 'Attach',
    --       url = 'http://localhost:3000',
    --       protocol = 'inspector',
    --     },
    --   }
    -- end
    -- require('dap').adapters['pwa-chrome'] = {
    --   type = 'server',
    --   port = 3000,
    --   executable = { command = 'node', args = { os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/js-debug-adapter/js-debug-adapter', 3000 } },
    -- }
    -- require('dap').configurations.javascript = {
    --   {
    --     type = 'chrome',
    --     name = 'Attach',
    --     request = 'attach',
    --     url = 'http://localhost:3000',
    --     webRoot = '${workspaceFolder}',
    --     trace = true,
    --   },
    --   {
    --     type = 'chrome',
    --     name = 'Launch with localhost',
    --     request = 'launch',
    --     url = 'http://localhost:3000',
    --     webRoot = '${workspaceFolder}',
    --     trace = true,
    --   },
    -- }
    -- dap.adapters.chrome = {
    --   type = 'executable',
    --   command = 'node',
    --   args = { os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/js-debug-adapter/js-debug-adapter' }, -- TODO adjust
    -- }
    --
    -- dap.configurations.javascript = { -- change this to javascript if needed
    --   {
    --     type = 'chrome',
    --     request = 'attach',
    --     program = '${file}',
    --     cwd = vim.fn.getcwd(),
    --     sourceMaps = true,
    --     protocol = 'inspector',
    --     port = 9222,
    --     webRoot = '${workspaceFolder}',
    --   },
    -- }
    --
    -- dap.configurations.typescript = { -- change to typescript if needed
    --   {
    --     type = 'chrome',
    --     request = 'attach',
    --     program = '${file}',
    --     cwd = vim.fn.getcwd(),
    --     sourceMaps = true,
    --     protocol = 'inspector',
    --     port = 9222,
    --     webRoot = '${workspaceFolder}',
    --   },
    -- }
    -- require('dap-vscode-js').setup {
    --   debugger_path = '~/.local/share/nvim/mason/packages/js-debug-adapter/',
    --   adapters = { 'pwa-chrome' },
    -- }
    --
    -- for _, language in ipairs { 'typescript', 'javascript' } do
    --   require('dap').configurations[language] = {
    --     {
    --       {
    --         type = 'pwa-chrome',
    --         request = 'attach',
    --         name = 'Attach',
    --         port = 9222,
    --         url = 'localhost',
    --         cwd = '${workspaceFolder}',
    --       },
    --     },
    --   }
    -- end
  end,
}
