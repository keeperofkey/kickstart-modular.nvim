-- core.lua - Core plugins
return {
  {
    'vhyrro/luarocks.nvim',
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },

  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- bigfile = { enabled = true }, -- needs to be config
      dashboard = {
        enabled = true,
        styles = {
          height = 64,
          width = 64,
        },
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
          { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
        sections = {
          -- {
          --   section = 'terminal',
          --   cmd = 'chafa ~/Pictures/clouds_bw2.jpg --format symbols --symbols vhalf --size 60x17 --stretch --clear; sleep .1',
          --   height = 17,
          --   padding = 1,
          -- },
          {
            -- pane = 2,
            { section = 'keys', gap = 1, padding = 1 },
            { section = 'startup' },
          },
        },
      }, -- needs to be config
      -- explorer = { enabled = true },-- needs to be config
      -- indent = { enabled = true },
      -- input = { enabled = true },-- needs to be config
      -- picker = { enabled = true },-- needs to be config
      -- notifier = { enabled = true },-- needs to be config
      -- quickfile = { enabled = true },-- needs to be config
      -- scope = { enabled = true },-- needs to be config
      scroll = {
        enabled = true,
        --   animate = { duration = { step = 5, total = 100 }, easing = 'linear' },
      },
      dim = { enabled = true },
      -- statuscolumn = { enabled = true },-- needs to be config
      -- words = { enabled = true },-- needs to be config
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = { modes = { search = { enabled = true } } },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {
      dir = vim.fn.stdpath 'state' .. '/sessions/', -- directory where session files are saved
      -- minimum number of file buffers that need to be open to save
      -- Set to 0 to always save
      need = 1,
      branch = true, -- use git branch to save session
    },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      lsp = {
        progress = { enabled = false },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      cmdline = { view = 'cmdline' },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      {
        'rcarriga/nvim-notify',
        config = function()
          require('notify').setup {
            timeout = 5000,
            stages = 'static',
            render = 'wrapped-compact',
            background_colour = '#000000',
          }
        end,
      },
    },
  },
  {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>tx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>tX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>ts',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>tl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>tL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>tQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  {
    'cbochs/grapple.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', lazy = true },
    },
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = 'Grapple',
    keys = {
      { '<leader>gg', '<cmd>Grapple toggle<cr>', desc = 'Grapple toggle tag' },
      { '<leader>gk', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple toggle tags' },
      { '<leader>gK', '<cmd>Grapple toggle_scopes<cr>', desc = 'Grapple toggle scopes' },
      { '<leader>gj', '<cmd>Grapple cycle forward<cr>', desc = 'Grapple cycle forward' },
      { '<leader>gJ', '<cmd>Grapple cycle backward<cr>', desc = 'Grapple cycle backward' },
      { '<leader>1', '<cmd>Grapple select index=1<cr>', desc = 'Grapple select 1' },
      { '<leader>2', '<cmd>Grapple select index=2<cr>', desc = 'Grapple select 2' },
      { '<leader>3', '<cmd>Grapple select index=3<cr>', desc = 'Grapple select 3' },
      { '<leader>4', '<cmd>Grapple select index=4<cr>', desc = 'Grapple select 4' },
    },
  },
  -- {
  --   'm4xshen/hardtime.nvim',
  --   dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
  --   opts = { disable_mouse = false, max_count = 5, allow_different_key = true },
  -- },
  -- {
  --   'nvimtools/none-ls.nvim',
  --   config = function()
  --     local null_ls = require 'null-ls'
  --     null_ls.setup {
  --       sources = {
  --         null_ls.builtins.formatting.stylua,
  --         -- null_ls.builtins.completion.spell,
  --         null_ls.builtins.code_actions.proselint,
  --         null_ls.builtins.completion.tags,
  --
  --         null_ls.builtins.formatting.biome,
  --         null_ls.builtins.formatting.black,
  --         null_ls.builtins.completion.luasnip,
  --       },
  --     }
  --   end,
  --   requires = { 'nvim-lua/plenary.nvim' },
  -- },
}
