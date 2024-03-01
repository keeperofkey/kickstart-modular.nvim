-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { 'folke/lazy.nvim', opts = { ui = { border = 'rounded' } } },
  {
    'stevearc/oil.nvim',
    opts = {
      keymaps = {
        ['<leader><leader>'] = 'actions.select',
      },
    },
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
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
      vim.keymap.set('n', '<leader>t', function()
        require('nvterm.terminal').toggle 'horizontal'
      end, { desc = 'Toggle little horizontal [t]erm' })
      vim.keymap.set('n', '<leader>T', function()
        require('nvterm.terminal').toggle 'vertical'
      end, { desc = 'Toggle vertical [T]erm split' })
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'gruvbox',
        component_separators = { left = '>', right = '<' },
        section_separators = { left = ' ', right = ' ' },
      },
      sections = {
        lualine_a = { { 'mode', padding = { left = 2, right = 2 } } },
        lualine_y = { 'location', 'progress' },
        lualine_z = {
          {
            function()
              return ' ' .. os.date '%R'
            end,
            padding = { left = 2, right = 2 },
          },
        },
      },
    },
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
  {
    'carlosrocha/chrome-remote.nvim',
    config = function()
      require('chrome-remote').setup { connection = { host = 'localhost', port = 9222 } }
    end,
  },
  {
    'sourcegraph/sg.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('sg').setup()
    end,
  },
}
