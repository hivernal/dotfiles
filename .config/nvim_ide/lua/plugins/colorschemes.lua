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
		},
	},
	{
		"shaunsingh/nord.nvim",
		lazy = false,
		priority = 1000,
	},
}
