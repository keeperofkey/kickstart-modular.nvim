-- Parse colors from xrdb (Xresources)
local function xresource(key)
  local handle = io.popen('xrdb -query 2>/dev/null | grep "\\*\\.' .. key .. ':" | head -1')
  if not handle then return nil end
  local result = handle:read '*a'
  handle:close()
  return result:match '#%x+'
end

local c = {
  bg         = xresource 'color0'     or '#0c0d0f',
  bg1        = '#23262b',
  bg2        = '#504945',
  dim        = xresource 'color8'     or '#515863', -- comments, line numbers
  fgdim      = '#bdae93',                            -- parameters, modules
  fg         = xresource 'foreground' or '#c9cdd1', -- main text
  fgbright   = '#ebdbb2',                            -- members
  fg1        = xresource 'color15'    or '#f2f3f4',
  red        = xresource 'color1'     or '#fb4934', -- keywords, errors
  purple     = xresource 'color5'     or '#be86d3', -- constants, numbers
  yellow     = xresource 'color3'     or '#fabd2f', -- types, warnings
  green      = xresource 'color2'     or '#b8bb26', -- strings, diff add
  cyan       = xresource 'color6'     or '#8ec07c', -- special, regex
  blue       = xresource 'color4'     or '#59a1c6', -- functions, info
  orange     = '#fe8019',                            -- keyword.function
  darkorange = '#d65d0e',
}

return {
  {
    'catgoose/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    dir = vim.fn.stdpath 'config',
    name = 'theme',
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      vim.cmd 'highlight clear'
      local hi = vim.api.nvim_set_hl
      local function apply()
        -- Editor / UI
        hi(0, 'Normal',        { fg = c.fg })
        hi(0, 'NormalNC',      { link = 'Normal' })
        hi(0, 'NormalFloat',   { fg = c.fg })
        hi(0, 'SignColumn',    {})
        hi(0, 'LineNr',        { fg = c.dim })
        hi(0, 'CursorLineNr',  { fg = c.fg, bg = c.bg1 })
        hi(0, 'FoldColumn',    { fg = c.dim })
        hi(0, 'WinSeparator',  { fg = c.dim })
        hi(0, 'VertSplit',     { link = 'WinSeparator' })
        hi(0, 'StatusLine',    {})
        hi(0, 'StatusLineNC',  { bg = c.bg1 })
        hi(0, 'TabLine',       {})
        hi(0, 'TabLineFill',   {})
        hi(0, 'TabLineSel',    {})
        hi(0, 'CursorLine',    { bg = c.bg1 })
        hi(0, 'ColorColumn',   { bg = c.bg1 })
        hi(0, 'FloatBorder',   { fg = c.dim })
        hi(0, 'FloatTitle',    { fg = c.blue, bold = true })
        hi(0, 'Visual',        { bg = c.bg2 })
        hi(0, 'Search',        { fg = c.bg, bg = c.yellow })
        hi(0, 'IncSearch',     { fg = c.bg, bg = c.orange })
        hi(0, 'MatchParen',    { fg = c.yellow, bold = true })
        hi(0, 'Folded',        { fg = c.dim, bg = c.bg1 })
        hi(0, 'Directory',     { fg = c.blue })
        hi(0, 'Title',         { fg = c.blue, bold = true })
        hi(0, 'Underlined',    { fg = c.blue, underline = true })

        -- Syntax (standard vim groups)
        hi(0, 'Comment',       { fg = c.dim, italic = true })
        hi(0, 'String',        { fg = c.green })
        hi(0, 'Character',     { fg = c.green })
        hi(0, 'Number',        { fg = c.purple })
        hi(0, 'Float',         { fg = c.purple })
        hi(0, 'Boolean',       { fg = c.purple })
        hi(0, 'Constant',      { fg = c.purple })
        hi(0, 'Identifier',    { fg = c.fg })
        hi(0, 'Function',      { fg = c.blue })
        hi(0, 'Keyword',       { fg = c.red })
        hi(0, 'Conditional',   { fg = c.red })
        hi(0, 'Repeat',        { fg = c.red })
        hi(0, 'Label',         { fg = c.red })
        hi(0, 'Exception',     { fg = c.red })
        hi(0, 'StorageClass',  { fg = c.red })
        hi(0, 'Operator',      { fg = c.fg })
        hi(0, 'Delimiter',     { fg = c.fg })
        hi(0, 'Type',          { fg = c.yellow })
        hi(0, 'Typedef',       { fg = c.yellow })
        hi(0, 'Structure',     { fg = c.yellow })
        hi(0, 'Special',       { fg = c.cyan })
        hi(0, 'SpecialChar',   { fg = c.cyan })
        hi(0, 'PreProc',       { fg = c.cyan })
        hi(0, 'Include',       { fg = c.cyan })
        hi(0, 'Define',        { fg = c.cyan })
        hi(0, 'Macro',         { fg = c.cyan })
        hi(0, 'Tag',           { fg = c.red })
        hi(0, 'Error',         { fg = c.red, bold = true })
        hi(0, 'Warning',       { fg = c.yellow })
        hi(0, 'Todo',          { fg = c.yellow, bold = true })

        -- Popup menu
        hi(0, 'Pmenu',         { fg = c.fg, bg = c.bg2 })
        hi(0, 'PmenuSel',      { fg = c.yellow, bg = c.bg2, bold = true })
        hi(0, 'PmenuSbar',     { bg = c.bg2 })
        hi(0, 'PmenuThumb',    { bg = c.dim })
        hi(0, 'PmenuKind',     { fg = c.fg })
        hi(0, 'PmenuKindSel',  { fg = c.yellow })

        -- Diagnostics
        hi(0, 'DiagnosticError',              { fg = c.red })
        hi(0, 'DiagnosticVirtualTextError',   { fg = c.red })
        hi(0, 'DiagnosticWarn',               { fg = c.yellow })
        hi(0, 'DiagnosticVirtualTextWarn',    { fg = c.yellow })
        hi(0, 'DiagnosticInfo',               { fg = c.blue })
        hi(0, 'DiagnosticVirtualTextInfo',    { fg = c.blue })
        hi(0, 'DiagnosticHint',               { fg = c.cyan })
        hi(0, 'DiagnosticVirtualTextHint',    { fg = c.cyan })
        hi(0, 'DiagnosticUnderlineError',     { underline = true, sp = c.red })
        hi(0, 'DiagnosticUnderlineWarn',      { underline = true, sp = c.yellow })
        hi(0, 'DiagnosticUnderlineInfo',      { underline = true, sp = c.blue })
        hi(0, 'DiagnosticUnderlineHint',      { underline = true, sp = c.cyan })
        hi(0, 'DiagnosticUnnecessary',        { underline = true })

        -- Diffs
        hi(0, 'DiffAdd',        { fg = c.green })
        hi(0, 'DiffChange',     { fg = c.yellow })
        hi(0, 'DiffDelete',     { fg = '#9d0006' })
        hi(0, 'DiffText',       { fg = c.fg1 })
        hi(0, 'NotificationInfo', {})

        -- Treesitter
        hi(0, '@variable',                  { fg = c.fg })
        hi(0, '@variable.member',           { fg = c.fgbright })
        hi(0, '@variable.parameter',        { fg = c.fgdim })
        hi(0, '@module',                    { fg = c.fgdim })
        hi(0, '@namespace',                 { fg = c.fgdim })
        hi(0, '@punctuation.delimiter',     { fg = c.fg })
        hi(0, '@keyword',                   { fg = c.red })
        hi(0, '@keyword.function',          { fg = c.orange })
        hi(0, '@keyword.return',            { fg = c.red })
        hi(0, '@keyword.operator',          { fg = c.red })
        hi(0, '@keyword.import',            { fg = c.red })
        hi(0, '@keyword.exception',         { fg = c.red })
        hi(0, '@keyword.conditional',       { fg = c.red })
        hi(0, '@keyword.repeat',            { fg = c.red })
        hi(0, '@keyword.storage',           { fg = c.red })

        -- LSP semantic token overrides
        -- Clear @lsp.type.variable so treesitter @constant etc. can show through
        hi(0, '@lsp.type.variable',  {})
        hi(0, 'TSProperty',          { link = '@variable.member' })
        hi(0, '@lsp.type.property',  { link = '@variable.member' })
        hi(0, 'TSParameter',         { link = '@variable.parameter' })
        hi(0, '@lsp.type.parameter', { link = '@variable.parameter' })

        -- Telescope
        hi(0, 'TelescopeNormal',          { link = 'NormalFloat' })
        hi(0, 'TelescopePromptNormal',    { link = 'NormalFloat' })
        hi(0, 'TelescopePreviewNormal',   { link = 'NormalFloat' })
        hi(0, 'TelescopeResultsNormal',   { link = 'NormalFloat' })
        hi(0, 'TelescopeBorder',          { link = 'FloatBorder' })
        hi(0, 'TelescopePromptBorder',    { link = 'FloatBorder' })
        hi(0, 'TelescopePreviewBorder',   { link = 'FloatBorder' })
        hi(0, 'TelescopeResultsBorder',   { link = 'FloatBorder' })
        hi(0, 'TelescopePromptPrefix',    { fg = c.red })
        hi(0, 'TelescopePromptTitle',     { fg = c.blue, bold = true })
        hi(0, 'TelescopePreviewTitle',    { fg = c.green, bold = true })
        hi(0, 'TelescopeResultsTitle',    { fg = c.purple, bold = true })
        hi(0, 'TelescopeSelection',       { bg = c.bg1 })
        hi(0, 'TelescopeMatching',        { fg = c.yellow, bold = true })

        -- Blink.cmp
        hi(0, 'BlinkCmpMenu',             { link = 'NormalFloat' })
        hi(0, 'BlinkCmpDoc',              { link = 'NormalFloat' })
        hi(0, 'BlinkCmpMenuBorder',       { link = 'FloatBorder' })
        hi(0, 'BlinkCmpDocBorder',        { link = 'FloatBorder' })
        hi(0, 'BlinkCmpDocSeparator',     { link = 'FloatBorder' })
        hi(0, 'BlinkCmpMenuSelection',    { fg = c.yellow, bold = true })
        hi(0, 'BlinkCmpLabel',            { fg = c.fg })
        hi(0, 'BlinkCmpLabelMatch',       { fg = c.yellow, bold = true })
        hi(0, 'BlinkCmpLabelDeprecated',  { fg = c.dim, strikethrough = true })

        -- Misc plugins
        hi(0, 'FlashMatch', { bg = c.green, fg = '#fffff0' })
        hi(0, 'FlashLabel', { bg = '#bbc0c5', fg = '#fffff0', bold = true, italic = true })
      end
      apply()
      vim.api.nvim_create_autocmd('ColorScheme', { callback = apply })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
