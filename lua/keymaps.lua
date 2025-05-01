-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
--  Mini sessions
vim.keymap.set('n', '<leader>m', function()
  require('mini.sessions').select()
end, { desc = 'Open Session [m]enu' })
-- Code & AI
vim.keymap.set('n', '<leader>cc', ':CodeCompanionChat<CR>', { desc = 'Open [C]ode [C]hat' })
vim.keymap.set('n', '<leader>ca', ':CodeCompanionActions<CR>', { desc = 'Open [C]ode [A]ctions' })
vim.keymap.set('n', '<leader>cx', ':CodeCompanionCmd<CR>', { desc = 'Open [C]ode [X] command' })
vim.keymap.set('n', '<leader>cs', ':Copilot suggestion toggle_auto_trigger<CR>', { desc = 'Toggle [C]ode [S]uggestiion' })

-- vim.cmd [[nnoremap <space>ss <cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<CR>]]
--  terminal
vim.keymap.set('n', '<leader>t', function()
  vim.cmd [[lcd %:p:h]]
  require('nvterm.terminal').new 'horizontal'
end, { desc = 'Open [t]erminal in horizontal split' })
vim.keymap.set('n', '<leader>T', function()
  vim.cmd [[lcd %:p:h]]
  require('nvterm.terminal').new 'vertical'
end, { desc = 'Open [T]erminal in vertical split' })

-- Tab
vim.keymap.set('i', '<Tab>', '<Tab>')

-- Window split
vim.keymap.set('n', '<leader>v', '<C-w><C-v>', { desc = 'Open [W]indow in vertical split' })
vim.keymap.set('n', '<leader>h', '<C-w><C-s>', { desc = 'Open [W]indow in horizontal split' })

-- Window movement
vim.keymap.set('n', '<leader>L', '<C-w>L', { desc = 'Move Window to the right [L]' })
vim.keymap.set('n', '<leader>J', '<C-w>J', { desc = 'Move Window to the bottom [J]' })

-- Window resize
vim.keymap.set('n', '<leader>we', '<C-w>=', { desc = '[W]indows [e]qual' })
vim.keymap.set('n', '<leader>wi', '<C-w>+', { desc = '[W]indow [i]ncrease height' })
vim.keymap.set('n', '<leader>wd', '<C-w>-', { desc = '[W]indow [d]ecrease height' })
vim.keymap.set('n', '<leader>wI', '<C-w><', { desc = '[W]indow [I]crease right' })
vim.keymap.set('n', '<leader>wD', '<C-w>>', { desc = '[W]indow [D]ecrease right' })

-- Page movement
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Page down and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Page up and center' })
-- Oil
-- vim.keymap.set('n', '<leader>-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Open Tab and move tabs
vim.keymap.set('n', '<leader><leader><Tab>', '<CMD>tabnew<CR>', { desc = 'Open new [T]ab' })
vim.keymap.set('n', '<leader>x', '<CMD>tabclose<CR>', { desc = '[x] Close current tab' })
vim.keymap.set('n', '<leader><Tab>', '<CMD>tabnext<CR>', { desc = 'Move to next [Tab]' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See :help lua-guide-autocommands

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
