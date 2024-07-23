return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  cmd = "TSUpdateSync",
  opts = {
    ensure_installed = { "c", "cpp", "lua" , "bash" },
    sync_install = false,
    auto_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    disable = { "help" },
  },
  enabled = true,
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end
}
