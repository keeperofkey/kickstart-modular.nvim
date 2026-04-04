# Telescope Modernization Design

## Goal

Reduce startup load time and fix the active `ft_to_lang` previewer crash, while keeping the existing telescope workflow intact.

## Changes

### 1. Lazy Loading

Move all `<leader>f*` keymaps from inside `config = function()` into the plugin spec's `keys = {}` table. Add `cmd = 'Telescope'` so command-triggered use also defers loading. Telescope will cost zero at startup and load on first use.

Keymaps that require a closure (current buffer fuzzy find, live grep in open files, find neovim files, find config files) stay in `config` as they cannot be expressed as simple command strings.

### 2. ft_to_lang Bug Fix

Add a one-line shim at the top of `config`:

```lua
if not vim.treesitter.ft_to_lang then
  vim.treesitter.ft_to_lang = vim.treesitter.language.get_lang
end
```

`vim.treesitter.ft_to_lang` was removed in Neovim 0.10. Telescope's previewer still calls it, causing a crash when previewing files with treesitter highlighting. This shim restores the expected API.

### 3. vimgrep Performance

Add `vimgrep_arguments` to `defaults` to skip irrelevant paths during grep:

- Exclude `.git`, `node_modules`, `dist`, `build`, `.cache`
- Use `--smart-case` and `--hidden` with explicit git ignore

### 4. Extensions Audit

- **Keep:** `fzf`, `ui-select`, `file_browser`, `luasnip`
- **Drop:** `glyph` — niche, no bound keymap, adds load overhead

## Files Changed

- `lua/kickstart/plugins/telescope.lua` — only file modified
