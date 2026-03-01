return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        presets = {
          operators = false
        }
      },
      defaults = {
        mode = { "n", "v" },
        ["<leader>l"] = { name = "+Lsp" },
        ["<leader>f"] = { name = "+File" },
        ["<leader>d"] = { name = "+Dap" },
        ["<leader>w"] = { name = "+Workspace" }
      }
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r", mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "<leader>/", mode = { "v", "n" }, desc = "Comment line" },
      { "<leader>?", mode = { "v", "n" }, desc = "Comment block" }
    },
    opts = {
      padding = true,
      sticky = true,
      ignore = nil,
      toggler = {
        line = "<leader>/",
        block = "<leader>?",
      },
      opleader = {
        line = "<leader>/",
        block = "<leader>?",
      },
      extra = {
        above = "gcO",
        below = "gco",
        eol = "gcA",
      },
      mappings = {
        basic = true,
        extra = true,
      },
      pre_hook = nil,
      post_hook = nil,
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = {
      scope = {
        enabled = true
      }
    }
  }
}
