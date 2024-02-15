local keymap = vim.keymap

keymap.set("i", "<c-ц>", "<c-w>")

keymap.set({ "i", "n", "c" }, "<D-space>", "")
keymap.set("i", "jj", "<esc>")
keymap.set("n", "<esc>", "<cmd>noh<cr>")
keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

keymap.set("n", "<leader>s", "<cmd>wa<cr>", { desc = "Save buffers" })
keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Close window" })

keymap.set("n", "<Tab>", "<cmd>bn<cr>")
keymap.set("n", "<S-Tab>", "<cmd>bp<cr>")

-- keymap.set("n", "<m-t>", "<cmd>10 new term://bash<cr>")
keymap.set("t", "<m-t>", [[<c-\><c-n>]])
keymap.set({"t", "n"}, "<m-h>", "<cmd>wincmd h<cr>")
keymap.set({"t", "n"}, "<m-l>", "<cmd>wincmd l<cr>")
keymap.set({"t", "n"}, "<m-j>", "<cmd>wincmd j<cr>")
keymap.set({"t", "n"}, "<m-k>","<cmd>wincmd k<cr>")
