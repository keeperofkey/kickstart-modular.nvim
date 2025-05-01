-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'vhyrro/luarocks.nvim',
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed.
      'nvim-telescope/telescope.nvim', -- optional
      -- "ibhagwan/fzf-lua",              -- optional
      -- "echasnovski/mini.pick",         -- optional
    },
    config = true,
  },
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
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  },
  { 'altermo/nwm', branch = 'x11' },
  -- {
  --   'epwalsh/obsidian.nvim',
  --   version = '*', -- recommended, use latest release instead of latest commit
  --   lazy = true,
  --   ft = 'markdown',
  --   -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  --   -- event = {
  --   --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   --   "BufReadPre path/to/my-vault/**.md",
  --   --   "BufNewFile path/to/my-vault/**.md",
  --   -- },
  --   dependencies = {
  --     -- Required.
  --     'nvim-lua/plenary.nvim',
  --
  --     -- see below for full list of optional dependencies 👇
  --   },
  --   opts = {
  --     workspaces = {
  --       {
  --         name = 'BrainStation',
  --         path = '~/Documents/BrainStation',
  --       },
  --     },
  --
  --     -- see below for full list of options 👇
  --   },
  -- },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  -- {
  --   'Exafunction/codeium.nvim',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'hrsh7th/nvim-cmp',
  --   },
  --   config = function()
  --     require('codeium').setup {}
  --   end,
  -- },
  -- {
  --   'NvChad/nvterm',
  --   config = function()
  --     require('nvterm').setup {
  --       shell = '/usr/bin/fish',
  --       terminals = {
  --         horizontal = { split_ratio = 0.2 },
  --         vertical = { split_ratio = 0.5 },
  --       },
  --     }
  --   end,
  -- },
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
  -- {
  --   'sourcegraph/sg.nvim',
  --   -- lazy = true,
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-telescope/telescope.nvim',
  --   },
  --   config = function()
  --     require('sg').setup {
  --       chat = { default_model = 'gpt-4o' },
  --     }
  --   end,
  -- },
  -- {
  --   'yetone/avante.nvim',
  --   event = 'VeryLazy',
  --   version = false, -- Never set this value to "*"! Never!
  --   opts = {
  --     -- add any opts here
  --     providers = { 'avante-cody' },
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = 'make',
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'stevearc/dressing.nvim',
  --     'nvim-lua/plenary.nvim',
  --     'MunifTanjim/nui.nvim',
  --     --- The below dependencies are optional,
  --     'echasnovski/mini.pick', -- for file_selector provider mini.pick
  --     'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
  --     'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
  --     'ibhagwan/fzf-lua', -- for file_selector provider fzf
  --     'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
  --     'zbirenbaum/copilot.lua', -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       'HakonHarnes/img-clip.nvim',
  --       event = 'VeryLazy',
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       'MeanderingProgrammer/render-markdown.nvim',
  --       opts = {
  --         file_types = { 'markdown', 'Avante' },
  --       },
  --       ft = { 'markdown', 'Avante' },
  --     },
  --     {
  --       'brewinski/avante-cody.nvim',
  --       opts = {
  --         providers = {
  --           ['avante-cody'] = {
  --             endpoint = 'https://sourcegraph.com',
  --             -- endpoint= 'https://<your_instance>.sourcegraphcloud.com',
  --             api_key_name = 'SRC_ACCESS_TOKEN',
  --             model = 'openai::2024-02-01::gpt-4.1',
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
  {
    'ravitemer/mcphub.nvim',
    build = 'npm install -g mcp-hub@latest',
    config = function()
      require('mcphub').setup()
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    opts = {
      strategies = {
        chat = {
          adapter = 'anthropic',
          schema = {
            model = {
              default = 'claude-3-7-sonnet-20250219',
            },
          },
        },
        inline = {
          adapter = 'copilot',
          --   -- schema = {
          --   --   model = {
          --   --     default = 'deepseek-ai/DeepSeek-R1-Distill-Qwen-32B',
          --   --   },
          --   -- },
        },
        cmd = {
          adapter = 'huggingface',
          schema = {
            model = {
              default = 'deepseek-ai/DeepSeek-R1-Distill-Qwen-32B',
            },
          },
        },
      },
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
    },
    dependencies = {
      'ravitemer/mcphub.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
          require('copilot').setup {
            filetypes = { ['*'] = true },
            suggestion = {
              keymap = {
                accept = '<C-S-Right>',
                next = '<C-S-Up>',
                prev = '<C-S-Down>',
              },
              auto_trigger = false,
            },
          }
        end,
      },
    },
  },
}
