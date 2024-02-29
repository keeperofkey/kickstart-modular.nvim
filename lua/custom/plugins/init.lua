-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
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
}
