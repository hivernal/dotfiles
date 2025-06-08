local keymap = vim.keymap

-- keymap.set("i", "<c-ц>", "<c-w>")

-- keymap.set({ "i", "n", "c", "t" }, "<D-space>", "")

keymap.set("i", "jj", "<esc>")
keymap.set("n", "<esc>", "<cmd>noh<cr>")
keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

keymap.set("n", "<leader>s", "<cmd>w<cr>", { desc = "Save buffer" })
keymap.set("n", "<leader>c", "<cmd>bd!<cr>", { desc = "Close buffer" })
keymap.set("n", "<leader>q", "<cmd>qa<cr>", { desc = "Close window" })
keymap.set("n", "<leader>n", "<cmd>bn<cr>", { desc = "Next buffer" })
keymap.set("n", "<leader>p", "<cmd>bp<cr>", { desc = "Previous buffer" })
keymap.set("n", "<leader>l", "<cmd>buffers<cr>", { desc = "List buffers" })

keymap.set("n", "<m-u>", "<c-u>")
keymap.set("n", "<m-d>", "<c-d>")

keymap.set("n", "<leader>t", "<c-]>")
keymap.set("n", "<leader>T", "<cmd>pop<cr>")

-- keymap.set("n", "<Tab>", "<cmd>bn<cr>")
-- keymap.set("n", "<S-Tab>", "<cmd>bp<cr>")

keymap.set("n", "<m-t>", "<cmd>10 new term://bash<cr>")
keymap.set("t", "<m-t>", [[<c-\><c-n>]])
keymap.set({"t", "n"}, "<m-h>", "<cmd>wincmd h<cr>")
keymap.set({"t", "n"}, "<m-l>", "<cmd>wincmd l<cr>")
keymap.set({"t", "n"}, "<m-j>", "<cmd>wincmd j<cr>")
keymap.set({"t", "n"}, "<m-k>","<cmd>wincmd k<cr>")
