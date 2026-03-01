local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    "hrsh7th/cmp-nvim-lsp-signature-help"
  },
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("cmp").setup({
      formatting = {
        format = function(_, vim_item)
          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
          vim_item.abbr = string.sub(vim_item.abbr, 1, 50)
          return vim_item
        end
      },

      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end
      },

      window = {
        completion = require("cmp").config.window.bordered(),
        documentation = require("cmp").config.window.bordered()
      },

      mapping = require("cmp").mapping.preset.insert({
        ["<C-b>"] = require("cmp").mapping.scroll_docs(-4),
        ["<C-f>"] = require("cmp").mapping.scroll_docs(4),
        ["<C-Space>"] = require("cmp").mapping.complete(),
        ["<C-e>"] = require("cmp").mapping.abort(),
        ["<CR>"] = require("cmp").mapping.confirm({ select = false }),
        ["<Tab>"] = require("cmp").mapping(function(fallback)
          if require("cmp").visible() then
            require("cmp").select_next_item()
          elseif require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = require("cmp").mapping(function(fallback)
          if require("cmp").visible() then
            require("cmp").select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          else
            fallback()
          end
        end, { "i", "s" })
      }),

      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        { name = 'nvim_lsp_signature_help' }
      }
    })
  end
}
