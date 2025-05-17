return {

  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  },
  { 'altermo/nwm', branch = 'x11' },
  -- {
  --   'iamcco/markdown-preview.nvim',
  --   cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  --   ft = { 'markdown' },
  --   build = function()
  --     vim.fn['mkdp#util#install']()
  --   end,
  -- },
  { 'nvim-tree/nvim-web-devicons' },
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
  -- ai
  {
    'Exafunction/windsurf.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('codeium').setup {
        enable_cmp_source = false,
        virtual_text = { enabled = true, key_bindings = { accept = '<C-Tab>' } },
      }
    end,
  },
  {
    'ravitemer/mcphub.nvim',
    -- build = 'npm install -g mcp-hub@latest',
    config = function()
      require('mcphub').setup {
        -- extensions = {
        --   avante = {
        --     make_slash_commands = true, -- make /slash commands from MCP server prompts
        --   },
        -- },
      }
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    opts = {
      adapters = {
        openrouter = function()
          return require('codecompanion.adapters').extend('openai_compatible', {
            env = {
              url = 'https://openrouter.ai/api',
              api_key = 'OPENROUTER_API_KEY',
              chat_url = '/v1/chat/completions',
            },
            schema = {
              model = {
                default = 'deepseek/deepseek-r1:free',
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'copilot',
          -- schema = {
          --   model = {
          --     default = 'claude-3-7-sonnet-20250219',
          --   },
          -- },
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
  --   'yetone/avante.nvim',
  --   event = 'VeryLazy',
  --   version = false, -- Never set this value to "*"! Never!
  --   opts = {
  --     selector = { provider = 'telescope' },
  --     provider = 'claude',
  --     cursour_applying_provider = 'copilot',
  --     -- openai = {
  --     --   endpoint = "https://api.openai.com/v1",
  --     --   model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
  --     --   timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
  --     --   temperature = 0,
  --     --   max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
  --     --   --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
  --     -- },
  --     behaviour = { enable_cursor_planning = true },
  --     windows = {
  --       position = 'right',
  --       fillchars = 'eob: ',
  --       wrap = true,
  --       width = 30,
  --       height = 30,
  --       sidebar_header = {
  --         enabled = false, -- Disabled header for cleaner look
  --         align = 'center',
  --         rounded = true,
  --       },
  --       input = {
  --         prefix = '> ',
  --         height = 8,
  --       },
  --       edit = {
  --         border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }, -- Minimal border
  --         start_insert = true,
  --       },
  --       ask = {
  --         -- floating = true, -- Changed to floating for cleaner appearance
  --         border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }, -- Minimal border
  --         start_insert = true,
  --         focus_on_apply = 'ours',
  --       },
  --     },
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
  --     'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
  --     'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
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
  --   },
  -- },
  {
    -- Make sure to set this up properly if you have lazy=true
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { 'markdown', 'Avante', 'codecompanion' },
      heading = { icons = { '# ', '## ', '### ', '#### ' } },
    },
    ft = { 'markdown', 'Avante', 'codecompanion' },
  },
}
