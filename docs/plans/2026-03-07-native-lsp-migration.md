# Native LSP Migration Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace the mason-lspconfig handler pattern in `lspconfig.lua` with Neovim 0.11 native LSP using `automatic_enable`, fixing the stylua crash and modernizing LSP setup.

**Architecture:** Remove the `servers` table and `handlers` block entirely. Set blink.cmp capabilities globally via `vim.lsp.config('*', {...})`. Use mason-lspconfig v2's `automatic_enable` to enable installed servers. Configure per-server settings with `vim.lsp.config('server', {...})`.

**Tech Stack:** Neovim 0.11.4, mason-lspconfig v2, blink.cmp, lazydev.nvim, typescript-tools.nvim (unchanged)

---

### Task 1: Set global capabilities and remove the old handler block

**Files:**
- Modify: `lua/kickstart/plugins/lspconfig.lua`

**Step 1: Read the current file**

Read `C:\Users\winvac\AppData\Local\nvim\lua\kickstart\plugins\lspconfig.lua` in full.

**Step 2: Replace the capabilities line and handler block**

Find this section (around line 148 to end of mason-lspconfig.setup):

```lua
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Enable the following language servers
-- ...comments...
local servers = {
  -- ...all the commented-out servers...
}

require('mason').setup {
  ui = { border = 'rounded' },
}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  'stylua',
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

require('mason-lspconfig').setup {
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      require('lspconfig')[server_name].setup {
        cmd = server.cmd,
        settings = server.settings,
        filetypes = server.filetypes,
        capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {}),
      }
    end,
    ['stylua'] = function() end,
    ['typescript-tools'] = function() end,
  },
}
```

Replace it with:

```lua
-- Set blink.cmp capabilities globally for all LSP servers
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- Per-server settings
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

require('mason').setup {
  ui = { border = 'rounded' },
}

require('mason-tool-installer').setup {
  ensure_installed = { 'stylua' },
}

require('mason-lspconfig').setup {
  ensure_installed = { 'lua_ls', 'pyright', 'clangd', 'bashls' },
  automatic_enable = {
    exclude = { 'stylua', 'typescript-tools' },
  },
}
```

**Step 3: Verify the file looks clean**

Read the file again. Confirm:
- No `local servers = {}` table
- No `handlers` block
- No `vim.tbl_deep_extend` capability threading
- `vim.lsp.config('*', {...})` is present
- `automatic_enable` with `exclude` is present

**Step 4: Commit**

```bash
git add lua/kickstart/plugins/lspconfig.lua
git commit -m "feat(lsp): migrate to mason-lspconfig v2 automatic_enable"
```

---

### Task 2: Verify stylua is no longer started as an LSP server

**Files:**
- Read: `C:\Users\winvac\AppData\Local\nvim-data\lsp.log`

**Step 1: Check the log before restart**

Note the timestamp of the last entry in the log.

**Step 2: Instruct user to restart Neovim and open a Lua file**

Tell the user: "Please restart Neovim and open any `.lua` file, then save it."

**Step 3: Check the log for new stylua entries**

Read the last 20 lines of `C:\Users\winvac\AppData\Local\nvim-data\lsp.log`.

Expected: No new `"rpc" "stylua"` entries after the `[START]` line for the new session.

If stylua entries still appear: the `vim.lsp.config('stylua', { enabled = false })` line in `init.lua` is the fallback — confirm it's still present.

**Step 4: Check LSP clients are attaching**

Tell the user: "Open a `.lua` file and run `:lua print(vim.inspect(vim.lsp.get_clients()))` — you should see `lua_ls` in the list."

**Step 5: Commit if clean**

```bash
git add .
git commit -m "fix(lsp): confirm stylua no longer starts as LSP server"
```

---

### Task 3: Install missing servers via Mason

**Context:** `ensure_installed` in mason-lspconfig will auto-install servers on next Neovim start, but only if the servers aren't already installed. This task verifies the right servers are present.

**Step 1: Instruct user to run :Lazy sync**

Tell the user: "Run `:Lazy sync` to ensure mason-lspconfig is up to date, then restart Neovim."

**Step 2: Check Mason status**

Tell the user: "Run `:Mason` — verify that `lua_ls`, `pyright`, `clangd`, and `bashls` are installed (green checkmarks). If any are missing, mason-lspconfig will install them automatically on the next restart."

**Step 3: Verify LSP attaches per filetype**

Test each language:
- Open a `.lua` file → `:lua print(vim.lsp.get_clients()[1].name)` should return `lua_ls`
- Open a `.py` file → should return `pyright`
- Open a `.c` or `.cpp` file → should return `clangd`
- Open a `.sh` file → should return `bashls`

**Step 4: Verify typescript-tools still works**

Open a `.ts` or `.js` file → `:lua print(vim.lsp.get_clients()[1].name)` should return `typescript-tools` (not `ts_ls`).

**Step 5: Commit**

```bash
git commit --allow-empty -m "chore(lsp): verified all language servers attach correctly"
```

---

### Task 4: Clean up init.lua if stylua is fixed

**Context:** `init.lua` currently has `vim.lsp.config('stylua', { enabled = false })` as a workaround. If Task 2 confirms stylua is no longer starting, this line can stay as documentation/safety. If it's still needed, leave it. Either way, note it with a comment.

**Files:**
- Modify: `init.lua` (only if needed)

**Step 1: Read init.lua**

Read `C:\Users\winvac\AppData\Local\nvim\init.lua`.

**Step 2: Ensure the comment is accurate**

The existing comment already explains why it's there. If stylua is confirmed fixed by `automatic_enable`, add a note that it's belt-and-suspenders. If it's still the only thing stopping stylua, leave it as-is.

The block should look like:
```lua
-- Disable stylua from being started as an LSP server.
-- lspconfig ships lsp/stylua.lua for nvim 0.11+ auto-LSP, but stylua --lsp
-- is not supported in released versions. Formatting is handled by conform.
-- Also excluded via mason-lspconfig automatic_enable.
vim.lsp.config('stylua', { enabled = false })
```

**Step 3: Commit if changed**

```bash
git add init.lua
git commit -m "chore(lsp): document stylua disable belt-and-suspenders"
```
