-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'microsoft/vscode-js-debug',
    opt = true,
    run = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out',
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  -- {
  --   'stevearc/oil.nvim',
  --   opts = {
  --     keymaps = {
  --       ['<leader><leader>'] = 'actions.select',
  --     },
  --   },
  --   -- Optional dependencies
  --   dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- },
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
  {
    'theprimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon').setup()
      vim.keymap.set('n', '<leader>ha', function()
        harpoon:list():append()
      end, { desc = '[H]arpoon [a]ppend' })
      vim.keymap.set('n', '<leader>hg', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = '[H]arpoon [g]ui' })

      vim.keymap.set('n', '<leader>hh', function()
        harpoon:list():select(1)
      end, { desc = '[H]arpoon [h]ead' })
      vim.keymap.set('n', '<leader>hj', function()
        harpoon:list():select(2)
      end, { desc = '[H]arpoon [j]ump' })
      vim.keymap.set('n', '<leader>hk', function()
        harpoon:list():select(3)
      end, { desc = '[H]arpoon mm[k]ay' })
      vim.keymap.set('n', '<leader>hl', function()
        harpoon:list():select(4)
      end, { desc = '[H]arpoon [l]ast' })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-S-P>', function()
        harpoon:list():prev()
      end)
      vim.keymap.set('n', '<C-S-N>', function()
        harpoon:list():next()
      end)
    end,
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
  {
    'sourcegraph/sg.nvim',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('sg').setup()
    end,
  },
}
