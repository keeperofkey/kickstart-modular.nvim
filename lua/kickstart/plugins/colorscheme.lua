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

      -- Transparency and highlight overrides (preserved from gruvbox config)
      local hi = vim.api.nvim_set_hl
      hi(0, 'Normal', { bg = 'none' })
      hi(0, 'NormalFloat', { bg = 'none' })
      hi(0, 'StatusLine', { bg = 'none' })
      hi(0, 'StatusLineNC', { bg = colors.base01 })
      hi(0, 'TabLine', { bg = 'none' })
      hi(0, 'TabLineFill', { bg = 'none' })
      hi(0, 'TabLineSel', { bg = 'none' })
      hi(0, 'CursorLine', { bg = colors.base01 })
      hi(0, 'Pmenu', { bg = 'none' })
      hi(0, 'PmenuSel', { bg = 'none', fg = colors.base0A, bold = true })
      hi(0, 'NotificationInfo', { bg = 'none' })
      hi(0, 'DiffAdd', { bg = 'none', fg = colors.base0B })
      hi(0, 'DiffChange', { bg = 'none', fg = colors.base0A })
      hi(0, 'DiffDelete', { bg = 'none', fg = '#9d0006' })
      hi(0, 'DiffText', { bg = 'none', fg = colors.base07 })
      hi(0, 'FlashMatch', { bg = colors.base0B, fg = '#fffff0' })
      hi(0, 'FlashLabel', { bg = '#bbc0c5', fg = '#fffff0', bold = true, italic = true })
      hi(0, 'Comment', { fg = colors.base03, italic = true })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
