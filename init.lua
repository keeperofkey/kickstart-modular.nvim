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

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

vim.cmd [[highlight CursorLine guibg=none gui=bold]]
vim.cmd [[highlight CursorLineNr guibg=none gui=bold]]
vim.cmd [[highlight Pmenu guibg=Gruvboxbg0]]
vim.cmd [[highlight PmenuSel guibg=none guifg=#fabd2f gui=bold]]
vim.cmd [[highlight NotificationInfo guibg=none]]
vim.cmd [[highlight DiffAdd guibg=none guifg=#b8bb26]]
vim.cmd [[highlight DiffChange guibg=none guifg=#fabd2f]]
vim.cmd [[highlight DiffDelete guibg=none guifg=#fb4934 ]]

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
