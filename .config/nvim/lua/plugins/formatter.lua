vim.pack.add({
  "https://github.com/mhartington/formatter.nvim",
})

require("formatter").setup({
  filetype = {
    lua = { require("formatter.filetypes.lua").stylua },
    cpp = { require("formatter.filetypes.cpp").clangformat },
    c = { require("formatter.filetypes.c").clangformat },
    python = { require("formatter.filetypes.python").autopep8 },
    go = { require("formatter.filetypes.go").gofmt },
    rust = { require("formatter.filetypes.rust").rustfmt },
    ["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
  },
})

vim.keymap.set("n", "<leader>f", "<cmd>Format<cr>", { desc = "Formatting" })
