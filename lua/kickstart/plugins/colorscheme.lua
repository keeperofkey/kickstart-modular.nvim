-- Parse colors from xrdb (Xresources)
local function xresource(key)
  local handle = io.popen('xrdb -query 2>/dev/null | grep "\\*\\.' .. key .. ':" | head -1')
  if not handle then return nil end
  local result = handle:read('*a')
  handle:close()
  local color = result:match('#%x+')
  return color
end

-- Fallback colors matching ~/.Xresources defaults
local colors = {
  base00 = xresource('color0') or '#0c0d0f',
  base01 = '#23262b',
  base02 = '#504945',
  base03 = xresource('color8') or '#515863',
  base04 = '#bdae93',
  base05 = xresource('foreground') or '#c9cdd1',
  base06 = '#ebdbb2',
  base07 = xresource('color15') or '#f2f3f4',
  base08 = xresource('color1') or '#fb4934',
  base09 = '#fe8019',
  base0A = xresource('color3') or '#fabd2f',
  base0B = xresource('color2') or '#b8bb26',
  base0C = xresource('color6') or '#8ec07c',
  base0D = xresource('color4') or '#59a1c6',
  base0E = xresource('color5') or '#be86d3',
  base0F = '#d65d0e',
}

return {
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    'RRethy/base16-nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      require('base16-colorscheme').setup(colors)

      -- Transparency overrides (bg = nil inherits terminal background)
      local hi = vim.api.nvim_set_hl

      -- Main editor transparency
      hi(0, 'Normal', { fg = colors.base05, bg = nil })
      hi(0, 'NormalNC', { link = 'Normal' })
      hi(0, 'NormalFloat', { fg = colors.base05, bg = nil })
      hi(0, 'SignColumn', { bg = nil })
      hi(0, 'LineNr', { fg = colors.base03, bg = nil })
      hi(0, 'CursorLineNr', { fg = colors.base05, bg = colors.base01 })
      hi(0, 'FoldColumn', { fg = colors.base03, bg = nil })
      hi(0, 'WinSeparator', { fg = colors.base03, bg = nil })
      hi(0, 'StatusLine', { bg = nil })
      hi(0, 'StatusLineNC', { bg = colors.base01 })
      hi(0, 'TabLine', { bg = nil })
      hi(0, 'TabLineFill', { bg = nil })
      hi(0, 'TabLineSel', { bg = nil })
      hi(0, 'CursorLine', { bg = colors.base01 })
      hi(0, 'FloatBorder', { fg = colors.base03, bg = nil })
      hi(0, 'FloatTitle', { fg = colors.base0D, bg = nil, bold = true })

      -- Popup menu (completion)
      hi(0, 'Pmenu', { fg = colors.base05, bg = colors.base02 })
      hi(0, 'PmenuSel', { fg = colors.base0A, bg = colors.base02, bold = true })
      hi(0, 'PmenuSbar', { bg = colors.base02 })
      hi(0, 'PmenuThumb', { bg = colors.base03 })

      -- Diffs
      hi(0, 'NotificationInfo', { bg = nil })
      hi(0, 'DiffAdd', { bg = nil, fg = colors.base0B })
      hi(0, 'DiffChange', { bg = nil, fg = colors.base0A })
      hi(0, 'DiffDelete', { bg = nil, fg = '#9d0006' })
      hi(0, 'DiffText', { bg = nil, fg = colors.base07 })

      -- Misc
      hi(0, 'FlashMatch', { bg = colors.base0B, fg = '#fffff0' })
      hi(0, 'FlashLabel', { bg = '#bbc0c5', fg = '#fffff0', bold = true, italic = true })
      hi(0, 'Comment', { fg = colors.base03, italic = true })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
