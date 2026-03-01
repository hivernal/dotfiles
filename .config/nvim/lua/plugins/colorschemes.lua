return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      styles = {
        keywords = { italic = false },
      },
      on_colors = function(colors)
        colors.fg = "#d2d9f8"
      end,
      on_highlights = function(hl, colors)
        hl["@variable"] = {
          fg = colors.fg
        }
        hl["@variable.parameter"] = "@variable"
        hl["@variable.member"] =  "@variable"
        hl["@variable.builtin"] = "@variable"
        hl["@property"] = {
          fg = colors.fg
        }
        hl["@function.macro"] = "@function"
        hl["@function.builtin"] = "@function"
        hl["@function.call"] = "@function"
        hl["@function.method"] = "@function"
        hl["@function.method.call"] = "@function"
        hl["@constant"] = {
          fg = colors.fg
        }
        hl["@constant.macro"] = "@constant"
        hl["@constant.builtin"] = "@constant"
        hl["@type"] = "@type.builtin"
        hl["@type.definition"] = "@type.builtin"
        hl["@operator"] = {
          fg = colors.fg
        }
        hl["@operator"] = {
          fg = colors.fg
        }
      end,
    },
  },
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
  },
}
