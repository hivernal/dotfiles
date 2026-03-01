return {
	{
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "<leader>e", "<cmd>NvimTreeFocus<cr>", desc = "File explorer" }
    },
    opts = {
      renderer = {
        root_folder_label = false,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        }
      }
    },
  },

	{
		"romgrk/barbar.nvim",
		event = "VeryLazy",
		dependencies = "nvim-tree/nvim-web-devicons",
		keys = {
			{ "<leader>c", "<cmd>BufferClose<cr>", desc = "Close buffer" },
			{ "<tab>", "<cmd>BufferNext<cr>", desc = "Next buffer" },
			{ "<s-tab>", "<cmd>BufferPrev<cr>", desc = "Previous buffer" },
		},
		opts = {
			animation = false,
			icons = {
				separator = { left = " ", right = "" },
				preset = "default",
			},
			sidebar_filetypes = {
				NvimTree = true,
				["neo-tree"] = { event = "BufWipeout" },
			},
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {},
	},
}
