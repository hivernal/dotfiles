return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"williamboman/mason.nvim",
			opts = {
				ensure_installed = {
					"lua-language-server",
					"cpptools",
					"stylua",
				},
			},
			config = function(_, opts)
				require("mason").setup(opts)
				vim.api.nvim_create_user_command("MasonInstallAll", function()
					vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
				end, {})
				vim.g.mason_binaries_list = opts.ensure_installed
			end,
		},

		{
			"mfussenegger/nvim-lint",
			config = function()
				require("lint").linters_by_ft = {
					cpp = { "cpplint" },
				}
				vim.api.nvim_create_autocmd({ "BufWritePost" }, {
					callback = function()
						require("lint").try_lint()
					end,
				})
			end,
		},

		{
			"mhartington/formatter.nvim",
			keys = {
				{ "<leader>lf", "<cmd>Format<cr>", desc = "Formatting" },
			},
			config = function()
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
			end,
		},
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		lspconfig.clangd.setup({ capabilities = capabilities })
		lspconfig.lua_ls.setup({ capabilities = capabilities })
		lspconfig.pyright.setup({ capabilities = capabilities })
		lspconfig.gopls.setup({ capabilities = capabilities })
		lspconfig.hls.setup({ capabilities = capabilities })
		lspconfig.rust_analyzer.setup({ capabilities = capabilities })

		local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end
		vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
		vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
		vim.keymap.set("n", "<leader>lc", vim.diagnostic.open_float, { desc = "Current diagnostic" })
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
				vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Declaration" })
				vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Definition" })
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf })
				vim.keymap.set(
					"n",
					"<leader>li",
					vim.lsp.buf.implementation,
					{ buffer = ev.buf, desc = "Implementation" }
				)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf })
				vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
				vim.keymap.set(
					{ "n", "v" },
					"<leader>la",
					vim.lsp.buf.code_action,
					{ buffer = ev.buf, desc = "Code action" }
				)
				-- vim.keymap.set("n", "<leader>lf", function()
				--   vim.lsp.buf.format { async = true }
				-- end, { buffer = ev.buf, desc = "Formatting" })
			end,
		})
	end,
}
