-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    -- event = 'VeryLazy',
    branch = '0.1.x',
    cmd = 'Telescope',
    keys = {
      { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = '[f]ind [h]elp' },
      { '<leader>fk', '<cmd>Telescope keymaps<cr>', desc = '[f]ind [k]eymaps' },
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = '[f]ind [f]iles' },
      { '<leader>fs', '<cmd>Telescope builtin<cr>', desc = '[f]ind [s]elect Telescope' },
      { '<leader>fw', '<cmd>Telescope grep_string<cr>', desc = '[f]ind current [w]ord' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = '[f]ind by [g]rep' },
      { '<leader>fd', '<cmd>Telescope diagnostics<cr>', desc = '[f]ind [d]iagnostics' },
      { '<leader>fr', '<cmd>Telescope resume<cr>', desc = '[f]ind [r]esume' },
      { '<leader>f.', '<cmd>Telescope oldfiles<cr>', desc = '[f]ind recent files' },
      { '<leader>fo', '<cmd>Telescope buffers<cr>', desc = '[f]ind [o]pen buffers' },
      { '<leader>fc', '<cmd>Telescope commands<cr>', desc = '[f]ind [c]ommands' },
      { '<leader>fz', '<cmd>Telescope spell_suggest<cr>', desc = '[f]ind [z] spelling' },
      { '<leader>fb', '<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>', desc = '[f]ile [b]rowser from current buffer' },
      { '<leader>fB', '<cmd>Telescope file_browser<cr>', desc = '[f]ile [B]rowser CWD' },
      { '<leader>fl', '<cmd>Telescope luasnip<cr>', desc = '[f]ind [l]uasnips' },
      { '<leader>/', desc = '[/] Fuzzily search in current buffer' },
      { '<leader>f/', desc = '[F]ind [/] in Open Files' },
      { '<leader>fn', desc = '[F]ind [N]eovim files' },
      { '<leader>fx', desc = '[F]ind [x] config files' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for install instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires special font.
      --  If you already have a Nerd Font, or terminal set up with fallback fonts
      --  you can enable this
      { 'nvim-tree/nvim-web-devicons' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
      -- { 'nvim-telescope/telescope-frecency.nvim' },
      -- { 'nvim-telescope/telescope-project.nvim' },
      { 'benfowler/telescope-luasnip.nvim' },
    },
    config = function()
      if not vim.treesitter.ft_to_lang then
        vim.treesitter.ft_to_lang = vim.treesitter.language.get_lang
      end
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of help_tags options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          --   mappings = {
          --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          --   },
          initial_mode = 'insert',
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob=!.git/*',
            '--glob=!node_modules/*',
            '--glob=!dist/*',
            '--glob=!build/*',
            '--glob=!.cache/*',
          },
        },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          ['file_browser'] = {
            layout_strategy = 'vertical',
            hijack_netrw = true,
            initial_mode = 'normal',
          },
        },
      }

      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'file_browser')
      -- pcall(require('telescope').load_extension, 'frecency')
      -- pcall(require('telescope').load_extension, 'project')
      pcall(require('telescope').load_extension, 'luasnip')

      -- See `:help telescope.builtin`
      -- Binds
      local builtin = require 'telescope.builtin'
      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- Also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>f/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[F]ind [/] in Open Files' })

      -- Shortcut for searching your neovim configuration files
      vim.keymap.set('n', '<leader>fn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[F]ind [N]eovim files' })
      vim.keymap.set('n', '<leader>fx', function()
        builtin.find_files { cwd = vim.fn.expand '$HOME/.config' }
      end, { desc = '[F]ind [x] config files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
