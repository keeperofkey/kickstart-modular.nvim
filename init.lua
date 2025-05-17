--[[
=====================================================================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true
-- vim.cmd 'colorscheme onedarkpro'

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

-- vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'TabLine', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'TabLineSel', { bg = 'none' })
-- -- vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#ffffff', blend = 50 })
-- -- vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'PmenuSel', { bg = 'none', fg = '#fabd2f', bold = true })
-- -- vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { bg = '#ebdbb2', fg = '#fabd2f' })
-- -- vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', { bg = '#ebdbb2', fg = '#fabd2f' })
-- vim.api.nvim_set_hl(0, 'NotificationInfo', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'DiffAdd', { bg = 'none', fg = '#b8bb26' })
-- vim.api.nvim_set_hl(0, 'DiffChange', { bg = 'none', fg = '#fabd2f' })
-- vim.api.nvim_set_hl(0, 'DiffDelete', { bg = 'none', fg = '#fb4934' })
--
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
