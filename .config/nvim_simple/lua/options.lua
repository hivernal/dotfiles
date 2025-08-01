local opt = vim.opt
local g = vim.g

opt.list = true
opt.listchars = { tab = "│ ", leadmultispace = "│ ", eol = "↲", space = "·" }
opt.textwidth = 80

-- opt.statusline = opt.statusline + "%F"
-- opt.laststatus = 2

opt.path = opt.path + "**"
-- opt.showmode = false
opt.colorcolumn = "80"

g.netrw_winsize = -30
g.netrw_keepdir = 0
g.netrw_banner = 0

opt.clipboard = "unnamedplus"
-- opt.cursorline = true

-- Indenting
opt.expandtab = false
opt.softtabstop = 2
opt.shiftwidth = 2
opt.tabstop = 8
opt.smartindent = true
opt.smarttab = true

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.relativenumber = true
opt.ruler = true

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeout = true
opt.timeoutlen = 1000
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 1000

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

g.mapleader = " "

-- g.loaded_netrw = 1
-- g.loaded_netrwPlugin = 1
-- g.barbar_auto_setup = false

--[[
-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  g["loaded_" .. provider .. "_provider"] = 0
end
]]
