-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = 'markdown',
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = {
        {
          name = 'BrainStation',
          path = '~/Documents/BrainStation',
        },
      },

      -- see below for full list of options 👇
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  {
    'Exafunction/codeium.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('codeium').setup {}
    end,
  },
  {
    'NvChad/nvterm',
    config = function()
      require('nvterm').setup {
        shell = '/usr/bin/fish',
        terminals = {
          horizontal = { split_ratio = 0.2 },
          vertical = { split_ratio = 0.5 },
        },
      }
    end,
  },
  { 'nvim-tree/nvim-web-devicons' },
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
          require('notify').setup { background_colour = '#000000' }
        end,
      },
    },
  },
  -- {
  --   'theprimeagen/harpoon',
  --   branch = 'harpoon2',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     local harpoon = require('harpoon').setup()
  --     vim.keymap.set('n', '<leader>ha', function()
  --       harpoon:list():append()
  --     end, { desc = '[H]arpoon [a]ppend' })
  --     vim.keymap.set('n', '<leader>hg', function()
  --       harpoon.ui:toggle_quick_menu(harpoon:list())
  --     end, { desc = '[H]arpoon [g]ui' })
  --
  --     vim.keymap.set('n', '<leader>hh', function()
  --       harpoon:list():select(1)
  --     end, { desc = '[H]arpoon [h]ead' })
  --     vim.keymap.set('n', '<leader>hj', function()
  --       harpoon:list():select(2)
  --     end, { desc = '[H]arpoon [j]ump' })
  --     vim.keymap.set('n', '<leader>hk', function()
  --       harpoon:list():select(3)
  --     end, { desc = '[H]arpoon mm[k]ay' })
  --     vim.keymap.set('n', '<leader>hl', function()
  --       harpoon:list():select(4)
  --     end, { desc = '[H]arpoon [l]ast' })
  --
  --     -- Toggle previous & next buffers stored within Harpoon list
  --     vim.keymap.set('n', '<C-S-P>', function()
  --       harpoon:list():prev()
  --     end)
  --     vim.keymap.set('n', '<C-S-N>', function()
  --       harpoon:list():next()
  --     end)
  --   end,
  -- },
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
  --   'carlosrocha/chrome-remote.nvim',
  --   config = function()
  --     require('chrome-remote').setup { connection = { host = 'localhost', port = 9222 } }
  --   end,
  -- },
  -- {
  --   'm4xshen/hardtime.nvim',
  --   dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
  --   opts = { disable_mouse = false, max_count = 5, allow_different_key = true },
  -- },
  -- {
  --   'kndndrj/nvim-dbee',
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --   },
  --   build = function()
  --     -- Install tries to automatically detect the install method.
  --     -- if it fails, try calling it with one of these parameters:
  --     --    "curl", "wget", "bitsadmin", "go"
  --     require('dbee').install()
  --   end,
  --   config = function()
  --     require('dbee').setup(--[[optional config]])
  --   end,
  -- },
  { 'tpope/vim-dadbod' },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion' },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    'sourcegraph/sg.nvim',
    -- lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('sg').setup()
    end,
  },
}
