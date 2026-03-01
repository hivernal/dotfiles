local keymap = vim.keymap

keymap.set("i", "<c-ц>", "<c-w>")

keymap.set({ "i", "n", "c" }, "<D-space>", "")
keymap.set("i", "jj", "<esc>")
keymap.set("n", "<esc>", "<cmd>noh<cr>")
keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

keymap.set("n", "<leader>s", "<cmd>wa<cr>", { desc = "Save buffers" })
keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Close window" })

keymap.set("n", "<c-h>", "<c-w>h")
keymap.set("n", "<c-l>", "<c-w>l")
keymap.set("n", "<c-j>", "<c-w>j")
keymap.set("n", "<c-k>", "<c-w>k")

keymap.set("i", "<c-h>", "<left>")
keymap.set("i", "<c-l>", "<right>")
keymap.set("i", "<c-j>", "<down>")
keymap.set("i", "<c-k>", "<up>")
