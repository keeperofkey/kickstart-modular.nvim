-- NOTE: Plugins can also be configured to run lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VeryLazy'
--
-- which loads which-key after all the UI elements are loaded. Events can be
-- normal autocommands events (:help autocomd-events).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VeryLazy', -- Sets the loading event to 'VeryLazy'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup {
        icons = {
          breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
          separator = '', -- symbol used between a key and it's label
          group = '+', -- symbol prepended to a group
        },
      }

      -- Document existing key chains
      require('which-key').add {
        { '<leader><space>', group = 'Tabs' },
        { '<leader>c', group = '[C]ode' },
        { '<leader>c_', hidden = true },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>d_', hidden = true },
        { '<leader>t', group = '[T]rouble' },
        { '<leader>t_', hidden = true },
        { '<leader>f', group = '[F]ind' },
        { '<leader>g', group = '[G]rapple' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>r_', hidden = true },
        { '<leader>s', group = '[S]earch' },
        { '<leader>s_', hidden = true },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>w_', hidden = true },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
