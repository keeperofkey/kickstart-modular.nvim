return {
  { -- Autoformat
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { 'isort', 'black' },
        markdown = { 'mdformat' },
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { 'prettierd', 'prettier' } },
        -- typescript = { { 'prettierd', 'prettier' } },
        typescript = { { 'biome', 'ast_grep', 'ts_standard' } },
        javascript = { { 'biome', 'ast_grep' } },
        svelte = { { 'biome', 'ast_grep' } },
        html = { { 'ast_grep' } },
        css = { { 'ast_grep' } },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
