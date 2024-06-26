return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
    'ellisonleao/gruvbox.nvim',
    -- 'folke/tokyonight.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      --   -- Load the colorscheme here
      require('gruvbox').setup {
        transparent_mode = true,
        palette_overrides = {},
        contrast = 'hard',
      }
      vim.cmd.colorscheme 'gruvbox'
      -- require('tokyonight').setup { transparent = true }
      -- vim.cmd.colorscheme 'tokyonight'
      --   -- You can configure highlights by doing something like
      vim.cmd.hi 'Comment guifg=none'
    end,
    -- opts = { transparent = true },
  },
}
-- vim: ts=2 sts=2 sw=2 et
