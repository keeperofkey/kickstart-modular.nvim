# Native LSP Migration Design

## Goal

Migrate from the lspconfig handler pattern to Neovim 0.11 native LSP with mason-lspconfig v2's `automatic_enable`. Fixes the stylua `--lsp` crash and modernizes the LSP setup.

## Approach: mason-lspconfig v2 automatic_enable

Keep mason-lspconfig but replace the handler block with `automatic_enable`. mason-lspconfig calls `vim.lsp.enable()` for each installed server, using configs from lspconfig's `lsp/` files. Capabilities set once globally. Server-specific settings via `vim.lsp.config()`.

## Section 1: Core mason-lspconfig setup

Replace the entire handler block with:

```lua
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

require('mason').setup { ui = { border = 'rounded' } }

require('mason-lspconfig').setup {
  ensure_installed = { 'lua_ls', 'pyright', 'clangd', 'bashls' },
  automatic_enable = {
    exclude = { 'stylua', 'typescript-tools' },
  },
}
```

## Section 2: Server-specific configs

```lua
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { disable = { 'missing-fields' } },
    },
  },
})

vim.lsp.config('pyright', {
  settings = {
    python = {
      analysis = { typeCheckingMode = 'basic' },
    },
  },
})
```

`clangd` and `bashls` use lspconfig defaults. `lua_ls` workspace config handled by lazydev.nvim.

## Section 3: What stays the same

- `LspAttach` autocmd with all keymaps
- `lazydev.nvim`
- `typescript-tools.nvim` (self-registers, excluded from automatic_enable)
- `mason-tool-installer.nvim` (for stylua formatter binary)
- `conform.nvim`
- `event = { 'BufReadPre', 'BufNewFile' }` on nvim-lspconfig

## What is removed

- The `servers` table
- The `handlers` block and all `vim.tbl_deep_extend` capability threading
- The no-op handlers for `stylua` and `typescript-tools`

## Files Changed

- `lua/kickstart/plugins/lspconfig.lua` — primary change
- `init.lua` — keep `vim.lsp.config('stylua', { enabled = false })` as belt-and-suspenders
