-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
local plugins = {

  -- [[ Plugin Specs list ]]

  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    opts = {
      ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---Lines to be ignored while (un)comment
      ignore = nil,
      ---LHS of toggle mappings in NORMAL mode
      toggler = {
        ---Line-comment toggle keymap
        line = 'gcc',
        ---Block-comment toggle keymap
        block = 'gbc',
      },
      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        ---Line-comment keymap
        line = 'gc',
        ---Block-comment keymap
        block = 'gb',
      },
      ---LHS of extra mappings
      extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA',
      },
      ---Enable keybindings
      ---NOTE: If given `false` then the plugin won't create any mappings
      mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
      },
      ---Function to call before (un)comment
      pre_hook = nil,
      ---Function to call after (un)comment
      post_hook = nil,
    },
  },

  -- modular approach: using `require 'path/name'` will
  -- include a plugin definition from file lua/path/name.lua
  --
  require 'kickstart/plugins/gitsigns',

  require 'kickstart/plugins/which-key',

  require 'kickstart/plugins/telescope',

  require 'kickstart/plugins/lspconfig',

  require 'kickstart/plugins/conform',

  require 'kickstart/plugins/cmp',

  require 'kickstart/plugins/colorscheme',

  require 'kickstart/plugins/todo-comments',

  require 'kickstart/plugins/mini',

  require 'kickstart/plugins/treesitter',

  require 'kickstart/plugins/lualine',

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- put them in the right spots if you want.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for kickstart
  --
  --  Here are some example plugins that I've included inthe kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information see: :help lazy.nvim-lazy.nvim-structuring-your-plugins
  { import = 'custom.plugins' },
}
local opts = {
  ui = { border = 'rounded' },
}

require('lazy').setup(plugins, opts)

local c_auto = require 'lualine.themes.gruvbox'
c_auto.normal.c.bg = 'none'
c_auto.normal.b.bg = 'none'
c_auto.normal.a.fg = '#689d6a'
c_auto.normal.a.bg = 'none'
c_auto.insert.c.bg = 'none'
c_auto.insert.c.fg = '#a89984'
c_auto.insert.b.bg = 'none'
c_auto.insert.a.fg = '#458588'
c_auto.insert.a.bg = 'none'
c_auto.visual.c.bg = 'none'
c_auto.visual.c.fg = '#a89984'
c_auto.visual.b.bg = 'none'
c_auto.visual.a.fg = '#d79921'
c_auto.visual.a.bg = 'none'
c_auto.replace.c.bg = 'none'
c_auto.replace.b.bg = 'none'
c_auto.replace.a.fg = '#cc241d'
c_auto.replace.a.bg = 'none'
c_auto.command.c.bg = 'none'
c_auto.command.c.fg = '#a89984'
c_auto.command.b.bg = 'none'
c_auto.command.a.fg = '#d65d0e'
c_auto.command.a.bg = 'none'
c_auto.inactive.c.bg = 'none'
c_auto.inactive.b.bg = 'none'
c_auto.inactive.a.fg = '#928374'
c_auto.inactive.a.bg = 'none'
require('lualine').setup { options = { theme = c_auto } }
-- vim: ts=2 sts=2 sw=2 et
