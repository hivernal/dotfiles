return {
  "nvim-lualine/lualine.nvim",
  enabled = false,
  event = "VeryLazy",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    sections = {
      lualine_c = { {'filename', path = 3} },
    },
  },
}
