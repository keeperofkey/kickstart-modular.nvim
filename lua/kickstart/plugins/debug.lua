-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  'mfussenegger/nvim-dap',
  keys = {
    { '<F5>',      desc = 'Debug: Start/Continue' },
    { '<F6>',      desc = 'Debug: Pause' },
    { '<F1>',      desc = 'Debug: Step Into' },
    { '<F2>',      desc = 'Debug: Step Over' },
    { '<F3>',      desc = 'Debug: Step Out' },
    { '<F7>',      desc = 'Debug: See last session result' },
    { '<leader>b', desc = 'Debug: Toggle Breakpoint' },
    { '<leader>B', desc = 'Debug: Set Breakpoint' },
  },
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    -- 'mfussenegger/nvim-dap-python',
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
        'codelldb',
        -- 'js-debug-adapter',
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F6>', dap.pause,    { desc = 'Debug: Pause (shows call stack while running)' })
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
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        enabled = true,
        element = 'repl', -- show the controls toolbar inside the repl panel
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
      -- Layout tuned for Unreal Engine C++ debugging:
      --   Left sidebar  – scopes (variable inspector), call stack, watches
      --   Bottom tray   – console (UE log output lands here), REPL for LLDB commands
      layouts = {
        {
          elements = {
            { id = 'scopes',  size = 0.50 }, -- locals / UE object members
            { id = 'stacks',  size = 0.35 }, -- deep UE call chains need decent height
            { id = 'watches', size = 0.15 }, -- pin GEngine, GWorld, specific actors
          },
          size = 55, -- columns
          position = 'left',
        },
        {
          elements = {
            { id = 'console', size = 0.65 }, -- UE LogOutput streams here
            { id = 'repl',    size = 0.35 }, -- LLDB expression/command input
          },
          size = 14, -- rows
          position = 'bottom',
        },
      },
    }

    -- DAP sign icons with highlight groups (without these, signs render blank/wrong colour)
    vim.fn.sign_define('DapBreakpoint',          { text = '●', texthl = 'DiagnosticError', linehl = '',       numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn',  linehl = '',       numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected',  { text = '●', texthl = 'DiagnosticHint',  linehl = '',       numhl = '' })
    vim.fn.sign_define('DapLogPoint',            { text = '◆', texthl = 'DiagnosticInfo',  linehl = '',       numhl = '' })
    vim.fn.sign_define('DapStopped',             { text = '→', texthl = 'DiagnosticWarn',  linehl = 'Visual', numhl = 'DiagnosticWarn' })

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- C++ adapter via codelldb (installed by mason)
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb.cmd',
        args = { '--port', '${port}' },
      },
    }

    -- Returns cached engine path, or auto-detects from Program Files, then prompts.
    -- Mirrors the logic in custom/plugins/unreal.lua so DAP configs work without
    -- needing to run a UE command first.
    local function ue_engine_path()
      if vim.g.ue_engine_path and vim.g.ue_engine_path ~= '' then
        return vim.g.ue_engine_path
      end
      local versions = vim.fn.glob('C:/Program Files/Epic Games/UE_*', false, true)
      local default = #versions > 0 and versions[#versions] or 'C:/Program Files/Epic Games/UE_5.5'
      local path = vim.fn.input('UE Engine path: ', default, 'dir')
      if path == '' then return nil end
      vim.g.ue_engine_path = path
      return path
    end

    -- Walks up from cwd looking for a .uproject (handles opening nvim from a subdir).
    local function find_uproject()
      local dir = vim.fn.getcwd()
      for _ = 1, 6 do
        local hits = vim.fn.glob(dir .. '/*.uproject', false, true)
        if #hits > 0 then return hits[1] end
        local parent = vim.fn.fnamemodify(dir, ':h')
        if parent == dir then break end
        dir = parent
      end
      return ''
    end

    -- Unreal Engine C++ debug configurations
    dap.configurations.cpp = {
      {
        name = 'UE: Attach to Editor',
        type = 'codelldb',
        request = 'attach',
        pid = function()
          return require('dap.utils').pick_process()
        end,
        stopOnEntry = false,
        -- Without this, stopping the debug session kills the UE editor process.
        detachOnTerminate = true,
        -- Native LLDB expression evaluator: no Python overhead, better UE type support.
        expressions = 'native',
        -- UE loads thousands of DLLs; attach causes LLDB to enumerate all of them
        -- at once, flooding codelldb's bounded event channel and dropping key events
        -- (stopped/threads/stackTrace). These commands reduce the noise somewhat.
        -- If Full(..) errors persist, run :MasonUpdate to get a newer codelldb with
        -- a larger channel buffer. Prefer the Launch config where possible.
        initCommands = {
          'settings set target.process.stop-on-exec false',
          'settings set symbols.enable-external-lookup false',
          'settings set target.preload-symbols false', -- defer symbol loading until needed; big speedup for UE's hundreds of DLLs
        },
      },
      {
        name = 'UE: Launch Editor (DebugGame)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          local engine = ue_engine_path()
          if not engine then return vim.fn.input('UnrealEditor.exe path: ', '', 'file') end
          return vim.fn.input('UnrealEditor.exe path: ', engine .. '/Engine/Binaries/Win64/UnrealEditor.exe', 'file')
        end,
        args = function()
          local uproject = find_uproject()
          if uproject == '' then
            uproject = vim.fn.input('.uproject path: ', '', 'file')
          end
          return { uproject, '-log' }
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        expressions = 'native',
        initCommands = {
          'settings set symbols.enable-external-lookup false',
          'settings set target.preload-symbols false',
        },
      },
      {
        name = 'UE: Launch Standalone Game (DebugGame)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          local uproject = find_uproject()
          local proj_dir = uproject ~= '' and vim.fn.fnamemodify(uproject, ':h') or vim.fn.getcwd()
          return vim.fn.input('Game .exe path: ', proj_dir .. '/Binaries/Win64/', 'file')
        end,
        args = { '-log' },
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        expressions = 'native',
        initCommands = {
          'settings set symbols.enable-external-lookup false',
          'settings set target.preload-symbols false',
        },
      },
    }

    -- Install golang specific config
    require('dap-go').setup()
    -- require('dap-python').setup '~/.virtualenvs/debugpy/bin/python'
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
