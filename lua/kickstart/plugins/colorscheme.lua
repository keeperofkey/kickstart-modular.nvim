-- Parse colors from xrdb (Xresources)
local function xresource(key)
  local handle = io.popen('xrdb -query 2>/dev/null | grep "\\*\\.' .. key .. ':" | head -1')
  if not handle then
    return nil
  end
  local result = handle:read '*a'
  handle:close()
  local color = result:match '#%x+'
  return color
end

-- Fallback colors matching ~/.Xresources defaults
local colors = {
  base00 = xresource 'color0' or '#0c0d0f',
  base01 = '#23262b',
  base02 = '#504945',
  base03 = xresource 'color8' or '#515863',
  base04 = '#bdae93',
  base05 = xresource 'foreground' or '#c9cdd1',
  base06 = '#ebdbb2',
  base07 = xresource 'color15' or '#f2f3f4',
  base08 = xresource 'color1' or '#fb4934',
  base09 = '#fe8019',
  base0A = xresource 'color3' or '#fabd2f',
  base0B = xresource 'color2' or '#b8bb26',
  base0C = xresource 'color6' or '#8ec07c',
  base0D = xresource 'color4' or '#59a1c6',
  base0E = xresource 'color5' or '#be86d3',
  base0F = '#d65d0e',
}

return {
  {
    'catgoose/nvim-colorizer.lua',
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
      require('base16-colorscheme').setup {
        base00 = colors.base00,
        base01 = colors.base01,
        base02 = colors.base02,
        base03 = colors.base03,
        base04 = colors.base04,
        base05 = colors.base05,
        base06 = colors.base06,
        base07 = colors.base07,
        base08 = colors.base08,
        base09 = colors.base09,
        base0A = colors.base0A,
        base0B = colors.base0B,
        base0C = colors.base0C,
        base0D = colors.base0D,
        base0E = colors.base0E,
        base0F = colors.base0F,
        telescope = false,
      }

      -- Transparency overrides
      local hi = vim.api.nvim_set_hl
      local function apply_transparency()
        -- Main editor
        hi(0, 'Normal', { fg = colors.base05 })
        hi(0, 'NormalNC', { link = 'Normal' })
        hi(0, 'NormalFloat', { fg = colors.base05 })
        hi(0, 'SignColumn', {})
        hi(0, 'LineNr', { fg = colors.base03 })
        hi(0, 'CursorLineNr', { fg = colors.base05, bg = colors.base01 })
        hi(0, 'FoldColumn', { fg = colors.base03 })
        hi(0, 'WinSeparator', { fg = colors.base03 })
        hi(0, 'StatusLine', {})
        hi(0, 'StatusLineNC', { bg = colors.base01 })
        hi(0, 'TabLine', {})
        hi(0, 'TabLineFill', {})
        hi(0, 'TabLineSel', {})
        hi(0, 'CursorLine', { bg = colors.base01 })
        hi(0, 'FloatBorder', { fg = colors.base03 })
        hi(0, 'FloatTitle', { fg = colors.base0D, bold = true })

        -- Popup menu
        hi(0, 'Pmenu', { fg = colors.base05, bg = colors.base02 })
        hi(0, 'PmenuSel', { fg = colors.base0A, bg = colors.base02, bold = true })
        hi(0, 'PmenuSbar', { bg = colors.base02 })
        hi(0, 'PmenuThumb', { bg = colors.base03 })
        hi(0, 'PmenuKind', { fg = colors.base05 })
        hi(0, 'PmenuKindSel', { fg = colors.base0A })

        -- Telescope
        hi(0, 'TelescopeNormal', { link = 'NormalFloat' })
        hi(0, 'TelescopeBorder', { link = 'FloatBorder' })
        hi(0, 'TelescopePromptNormal', { link = 'NormalFloat' })
        hi(0, 'TelescopePromptBorder', { link = 'FloatBorder' })
        hi(0, 'TelescopePromptPrefix', { fg = colors.base08 })
        hi(0, 'TelescopePromptTitle', { fg = colors.base0D, bold = true })
        hi(0, 'TelescopePreviewTitle', { fg = colors.base0B, bold = true })
        hi(0, 'TelescopeResultsTitle', { fg = colors.base09, bold = true })
        hi(0, 'TelescopePreviewNormal', { link = 'NormalFloat' })
        hi(0, 'TelescopePreviewBorder', { link = 'FloatBorder' })
        hi(0, 'TelescopeResultsNormal', { link = 'NormalFloat' })
        hi(0, 'TelescopeResultsBorder', { link = 'FloatBorder' })
        hi(0, 'TelescopeSelection', { fg = colors.base05, bg = colors.base01 })
        hi(0, 'TelescopeMatching', { fg = colors.base0A, bold = true })

        -- Diffs
        hi(0, 'NotificationInfo', {})
        hi(0, 'DiffAdd', { fg = colors.base0B })
        hi(0, 'DiffChange', { fg = colors.base0A })
        hi(0, 'DiffDelete', { fg = '#9d0006' })
        hi(0, 'DiffText', { fg = colors.base07 })

        -- Blink completion
        hi(0, 'BlinkCmpMenu', { link = 'NormalFloat' })
        hi(0, 'BlinkCmpMenuBorder', { link = 'FloatBorder' })
        hi(0, 'BlinkCmpMenuSelection', { fg = colors.base0A, bold = true })
        hi(0, 'BlinkCmpDoc', { link = 'NormalFloat' })
        hi(0, 'BlinkCmpDocBorder', { link = 'FloatBorder' })
        hi(0, 'BlinkCmpDocSeparator', { link = 'FloatBorder' })
        hi(0, 'BlinkCmpLabel', { fg = colors.base05 })
        hi(0, 'BlinkCmpLabelMatch', { fg = colors.base0A, bold = true })
        hi(0, 'BlinkCmpLabelDeprecated', { fg = colors.base03, strikethrough = true })

        -- Misc
        hi(0, 'FlashMatch', { bg = colors.base0B, fg = '#fffff0' })
        hi(0, 'FlashLabel', { bg = '#bbc0c5', fg = '#fffff0', bold = true, italic = true })
        hi(0, 'Comment', { fg = colors.base03, italic = true })
      end

      apply_transparency()
      vim.api.nvim_create_autocmd('ColorScheme', { callback = apply_transparency })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
