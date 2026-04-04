return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false, -- does not support lazy-loading
    build = ':TSUpdate',
    init = function(plugin)
      -- nvim-treesitter v1.0 stores queries under runtime/queries/ rather than queries/
      -- lazy.nvim only adds the plugin root to rtp, so we add the subdirectory manually
      vim.opt.rtp:prepend(plugin.dir .. '/runtime')
    end,
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer zig as compiler (available via chocolatey, works without MSVC env setup)
      require('nvim-treesitter.install').compilers = { 'zig' }

      -- Install parsers (no-op if already installed)
      require('nvim-treesitter').install { 'python', 'bash', 'c', 'cpp', 'html', 'lua', 'markdown', 'markdown_inline', 'vim', 'vimdoc' }

      -- Enable treesitter highlighting and folding for any filetype with an installed parser
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match) or args.match
          if pcall(vim.treesitter.language.inspect, lang) then
            vim.treesitter.start()
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo[0][0].foldmethod = 'expr'
            vim.wo[0][0].foldlevel = 99 -- open all folds by default
          end
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
