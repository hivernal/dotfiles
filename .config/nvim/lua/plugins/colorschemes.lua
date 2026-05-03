vim.pack.add({
  "https://github.com/folke/tokyonight.nvim",
  -- "shaunsingh/nord.nvim",
})

require("tokyonight").setup({
  style = "night",
  styles = {
    keywords = { italic = false },
  },
  on_colors = function(colors)
    colors.fg = "#d2d9f8"
  end,
  on_highlights = function(hl, colors)
    hl["@variable"] = { fg = colors.fg }
    hl["@punctuation"] = { fg = colors.fg }
    hl["@punctuation.bracket"] = "@punctuation"
    hl["@punctuation.delimiter"] = "@punctuation"
    hl["@punctuation.special"] = "@punctuation"
    hl["@character.special"] = { fg = colors.fg }
    hl["@variable.parameter"] = "@variable"
    hl["@variable.member"] =  "@variable"
    hl["@variable.builtin"] = "@variable"
    hl["@property"] = { fg = colors.fg }
    hl["@function.macro"] = "@function"
    hl["@function.builtin"] = "@function"
    hl["@function.call"] = "@function"
    hl["@function.method"] = "@function"
    hl["@function.method.call"] = "@function"
    hl["@constant"] = { fg = colors.fg }
    hl["Constant"] = { fg = colors.fg }
    hl["@constant.macro"] = "@constant"
    hl["@constant.builtin"] = "@constant"
    hl["@type"] = "@type.builtin"
    hl["@type.definition"] = "@type.builtin"
    hl["@operator"] = { fg = colors.fg }
  end,
})

-- vim.g.nord_bold  = false
-- vim.g.nord_contrast = true
-- vim.g.nord_italic = false
vim.cmd("colorscheme tokyonight")
