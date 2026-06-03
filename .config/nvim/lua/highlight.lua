local colors = {
  fg = "#d2d9f8",
  -- fg = "#e0e2ea",
  green = "#9ece6a",
  dark_green = "#27a1b9",
  cyan = "#7dcfff",
  magenta = "#bb9af7",
  blue = "#7aa2f7",
  gray = "#565f89"
}

vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg })
vim.api.nvim_set_hl(0, "Statement", { fg = colors.magenta })
vim.api.nvim_set_hl(0, "Type", { fg = colors.dark_green })
vim.api.nvim_set_hl(0, "String", { fg = colors.green })
vim.api.nvim_set_hl(0, "Identifier", { fg = colors.blue })
vim.api.nvim_set_hl(0, "Function", { fg = colors.blue })
vim.api.nvim_set_hl(0, "Operator", { fg = colors.fg })
vim.api.nvim_set_hl(0, "Constant", { fg = colors.fg })
vim.api.nvim_set_hl(0, "Comment", { fg = colors.gray })
vim.api.nvim_set_hl(0, "PreProc", {})

vim.api.nvim_set_hl(0, "cMacros", { fg = colors.cyan })

vim.api.nvim_set_hl(0, "luaTable", { fg = colors.fg })

vim.api.nvim_set_hl(0, "shVariable", { fg = colors.fg })
vim.api.nvim_set_hl(0, "shTestOpr", { fg = colors.fg })
vim.api.nvim_set_hl(0, "shOption", { fg = colors.fg })
vim.api.nvim_set_hl(0, "shCommandSub", { fg = colors.fg })
vim.api.nvim_set_hl(0, "shDerefVar", { fg = colors.fg })
vim.api.nvim_set_hl(0, "shDeref", { fg = colors.fg })
vim.api.nvim_set_hl(0, "shCmdSubRegion", { fg = colors.fg })
vim.api.nvim_set_hl(0, "shArithRegion", { fg = colors.fg })
vim.api.nvim_set_hl(0, "shQuote", { fg = colors.green })

vim.api.nvim_set_hl(0, "zigVarDecl", { link = "Statement" })
vim.api.nvim_set_hl(0, "zigFunction", { link = "Function" })
vim.api.nvim_set_hl(0, "zigDummyVariable", { fg = colors.fg })
