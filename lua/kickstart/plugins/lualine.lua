return {

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = function()
      local lualine = require 'lualine'
      local none = 'none'
      local c_auto = {
        normal   = { a = { fg = '#689d6a', bg = none, gui = 'bold' }, b = { fg = '#a89984', bg = none }, c = { fg = '#a89984', bg = none } },
        insert   = { a = { fg = '#458588', bg = none, gui = 'bold' }, b = { fg = '#a89984', bg = none }, c = { fg = '#a89984', bg = none } },
        visual   = { a = { fg = '#d79921', bg = none, gui = 'bold' }, b = { fg = '#a89984', bg = none }, c = { fg = '#a89984', bg = none } },
        replace  = { a = { fg = '#cc241d', bg = none, gui = 'bold' }, b = { fg = '#a89984', bg = none }, c = { fg = '#a89984', bg = none } },
        command  = { a = { fg = '#d65d0e', bg = none, gui = 'bold' }, b = { fg = '#a89984', bg = none }, c = { fg = '#a89984', bg = none } },
        inactive = { a = { fg = '#928374', bg = none }, b = { fg = '#928374', bg = none }, c = { fg = '#928374', bg = none } },
      }
      local function cmd_messege()
        return vim.cmd.messages(1)
      end
      local function show_macro_recording()
        local recording_register = vim.fn.reg_recording()
        if recording_register == '' then
          return ''
        else
          return 'Recording @' .. recording_register
        end
      end
      local macro_refresh_places = { 'statusline', 'winbar' }
      vim.api.nvim_create_autocmd('RecordingEnter', {
        callback = function()
          lualine.refresh {
            place = macro_refresh_places,
          }
        end,
      })
      vim.api.nvim_create_autocmd('RecordingLeave', {
        callback = function()
          lualine.refresh {
            place = macro_refresh_places,
          }
        end,
      })

      return {
        options = {
          theme = c_auto,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
        tabline = {
          lualine_a = {},
          lualine_b = { { 'tabs', symbols = { modified = '~' } } },
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'windows' },
        },
        sections = {
          lualine_a = { { 'mode', padding = { left = 0, right = 1 } } },
          lualine_b = { { 'branch', icon = '' }, 'diff', 'diagnostics' },
          lualine_c = {
            {
              'macro-recording',
              color = {
                fg = '#FF9E3B',
              },
              fmt = show_macro_recording,
            },
            cmd_messege,
          },
          lualine_x = { 'filetype' },
          lualine_y = { 'location' },
          lualine_z = {
            {
              function()
                return '  ' .. os.date '%R'
              end,
              padding = { left = 2, right = 1 },
            },
          },
        },
        highlights = {
          -- background = 'none',
        },
      }
    end,
  },
}
