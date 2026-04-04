# Telescope Modernization Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Modernize `lua/kickstart/plugins/telescope.lua` to fix an active previewer crash, add proper lazy loading, and tune grep performance.

**Architecture:** Single file edit — move keymaps into the lazy.nvim `keys` spec for deferred loading, add a one-line `ft_to_lang` shim, add `vimgrep_arguments` to defaults, and remove the `glyph` extension.

**Tech Stack:** Neovim 0.10+, lazy.nvim, telescope.nvim, telescope-fzf-native.nvim

---

### Task 1: Fix the ft_to_lang previewer crash

**Files:**
- Modify: `lua/kickstart/plugins/telescope.lua`

**Step 1: Add the shim at the top of the config function**

In `config = function()`, add this as the very first line before `require('telescope').setup`:

```lua
if not vim.treesitter.ft_to_lang then
  vim.treesitter.ft_to_lang = vim.treesitter.language.get_lang
end
```

**Step 2: Verify the fix**

Open Neovim, run `:Telescope find_files`, navigate over some files in the previewer. The `attempt to call field 'ft_to_lang' (a nil value)` error should not appear in the bottom-right notification area.

**Step 3: Commit**

```bash
git add lua/kickstart/plugins/telescope.lua
git commit -m "fix(telescope): shim ft_to_lang for nvim 0.10 compatibility"
```

---

### Task 2: Add vimgrep_arguments to defaults

**Files:**
- Modify: `lua/kickstart/plugins/telescope.lua`

**Step 1: Replace the current `defaults` block**

Find the current `defaults` block (around line 66):

```lua
defaults = {
  initial_mode = 'insert',
},
```

Replace it with:

```lua
defaults = {
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
```

Note: This requires `ripgrep` (`rg`) to be installed. If not installed, omit `vimgrep_arguments` entirely — telescope falls back to `grep`.

**Step 2: Verify**

Open Neovim, run `<leader>fg` (live grep). Search for something. It should work and skip the excluded directories.

**Step 3: Commit**

```bash
git add lua/kickstart/plugins/telescope.lua
git commit -m "perf(telescope): add vimgrep_arguments to skip large dirs"
```

---

### Task 3: Drop glyph extension

**Files:**
- Modify: `lua/kickstart/plugins/telescope.lua`

**Step 1: Remove from dependencies**

Remove this line from the `dependencies` table:

```lua
{ 'ghassan0/telescope-glyph.nvim' },
```

**Step 2: Remove the load_extension call**

Remove this line from the config function:

```lua
pcall(require('telescope').load_extension, 'glyph')
```

**Step 3: Verify**

Open Neovim, run `:Lazy` — `telescope-glyph.nvim` should no longer appear. No errors on startup.

**Step 4: Commit**

```bash
git add lua/kickstart/plugins/telescope.lua
git commit -m "chore(telescope): remove unused glyph extension"
```

---

### Task 4: Add lazy loading via keys spec

This is the biggest startup win. Lazy.nvim defers loading a plugin until one of its registered keys is pressed.

**Files:**
- Modify: `lua/kickstart/plugins/telescope.lua`

**Step 1: Add cmd and keys to the plugin spec**

In the plugin spec table (top level, alongside `branch`, `dependencies`, `config`), add:

```lua
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
```

Note: The last four entries (with no `cmd` string) just register the keys so lazy.nvim knows to load telescope when they're pressed. The actual behavior is still defined in the `config` function via `vim.keymap.set`.

**Step 2: Remove duplicate keymap.set calls from config for simple keymaps**

In `config = function()`, remove the `vim.keymap.set` calls for all the simple keymaps now covered by the `keys` spec above. Keep only the closure-based ones that can't be expressed as a command string:

```lua
-- KEEP these (closures):
vim.keymap.set('n', '<leader>/', function() ... end, ...)
vim.keymap.set('n', '<leader>f/', function() ... end, ...)
vim.keymap.set('n', '<leader>fn', function() ... end, ...)
vim.keymap.set('n', '<leader>fx', function() ... end, ...)

-- REMOVE the rest (now handled by keys spec)
```

**Step 3: Verify lazy loading works**

Open Neovim. Run `:Lazy` — telescope should show as "not loaded". Press `<leader>ff`. Telescope opens. Run `:Lazy` again — telescope should now show as loaded.

**Step 4: Verify all keymaps still work**

Test a sample of: `<leader>ff`, `<leader>fg`, `<leader>fb`, `<leader>fl`, `<leader>/`, `<leader>fn`.

**Step 5: Commit**

```bash
git add lua/kickstart/plugins/telescope.lua
git commit -m "perf(telescope): lazy load via keys spec"
```

---

### Task 5: Final review

**Step 1: Check the full file looks clean**

Read `lua/kickstart/plugins/telescope.lua` in full. Verify:
- `ft_to_lang` shim is the first line in `config`
- `vimgrep_arguments` is in `defaults`
- `glyph` is gone from both `dependencies` and `load_extension` calls
- `cmd = 'Telescope'` and `keys = { ... }` are in the plugin spec
- Only closure-based keymaps remain in `config`

**Step 2: Restart Neovim clean**

Close and reopen Neovim. Confirm no errors on startup. Confirm telescope is not loaded at startup via `:Lazy`.
