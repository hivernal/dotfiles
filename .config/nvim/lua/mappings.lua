local keymap = vim.keymap

-- keymap.set("i", "<c-ц>", "<c-w>")

-- keymap.set({ "i", "n", "c", "t" }, "<D-space>", "")

keymap.set("i", "jj", "<esc>")
keymap.set("n", "<esc>", "<cmd>noh<cr>")
-- keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

keymap.set("n", "<leader>s", "<cmd>w<cr>", { desc = "Write buffer" })
keymap.set("n", "<leader>d", "<cmd>bd!<cr>", { desc = "Delete buffer" })
keymap.set("n", "<leader>w", "<cmd>bw!<cr>", { desc = "Wipeout buffer" })
keymap.set("n", "<leader>l", "<cmd>buffers<cr>", { desc = "List buffers" })
keymap.set("n", "<leader>L", "<cmd>buffers!<cr>", { desc = "List all buffers" })
keymap.set("n", "<leader>n", "<cmd>bn<cr>", { desc = "Next buffer" })
keymap.set("n", "<leader>p", "<cmd>bp<cr>", { desc = "Previous buffer" })

keymap.set("n", "<leader>c", "<cmd>close<cr>", { desc = "Close window" })
keymap.set("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit" })

keymap.set("n", "<leader>e", "<cmd>Lexplore<cr>", { desc = "toggle file explorer" })
keymap.set("n", "<leader>E", "<cmd>Lexplore %:p:h<cr>", { desc = "toggle file explorer" })

keymap.set("n", "<m-u>", "<c-u>")
keymap.set("n", "<m-d>", "<c-d>")

keymap.set("n", "<leader>m", "<cmd>marks<cr>")
keymap.set("n", "<leader>r", "<cmd>registers<cr>")
keymap.set("n", "<leader>j", "<cmd>jumps<cr>")
keymap.set("n", "<leader>C", "<cmd>changes<cr>")

keymap.set("n", "<leader>t", "<c-]>")
keymap.set("n", "<leader>T", "<cmd>pop<cr>")

-- keymap.set("n", "<Tab>", "<cmd>bn<cr>")
-- keymap.set("n", "<S-Tab>", "<cmd>bp<cr>")

keymap.set("n", "<leader>b", "<cmd>10split term://bash | set nobuflisted<cr>")
keymap.set("t", "<m-b>", [[<c-\><c-n>]])
keymap.set({"t", "n"}, "<m-h>", "<cmd>wincmd h<cr>")
keymap.set({"t", "n"}, "<m-l>", "<cmd>wincmd l<cr>")
keymap.set({"t", "n"}, "<m-j>", "<cmd>wincmd j<cr>")
keymap.set({"t", "n"}, "<m-k>","<cmd>wincmd k<cr>")

--[[
vim.lsp.config['clangd'] = {
  cmd = { 'clangd' },
  -- Filetypes to automatically attach to.
  filetypes = { 'c', 'cpp', 'h', 'hpp' }
}
vim.lsp.enable('clangd')
--]]
