return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = "nvim-lua/plenary.nvim",
  tag = "0.1.2",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>",                 desc = "Grep files" },
    { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in buffer" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = "Find buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>",                 desc = "Help tags" },
    { "<leader>lr", "<cmd>Telescope lsp_references<cr>",            desc = "Lsp references" },
    { "<leader>lq", "<cmd>Telescope diagnostics<cr>",               desc = "Lsp diagnostics" },
    { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>",      desc = "Document symbols" },
    { "<leader>lt", "<cmd>Telescope treesitter<cr>",                desc = "Treesitter" }
  },
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = actions.close
          },
          n = {
            ["q"] = actions.close
          }
        }
      }
    })
  end
}
