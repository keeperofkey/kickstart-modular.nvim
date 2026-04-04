return {
  { -- Autoformat
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { 'isort', 'black' },
        markdown = { 'mdformat' },
        typescript = { 'biome' },
        javascript = { 'biome' },
        json = { 'biome' },
        svelte = { 'biome' },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
