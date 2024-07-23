local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }

local function quotes_rules()
  local npairs = require("nvim-autopairs")
  local Rule = require("nvim-autopairs.rule")
  local cond = require("nvim-autopairs.conds")
  npairs.add_rules({
    -- Rule for a pair with left-side " " and right side " "
    Rule(" ", " ")
    -- Pair will only occur if the conditional function returns true
        :with_pair(function(opts)
          -- We are checking if we are inserting a space in (), [], or {}
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({
            brackets[1][1] .. brackets[1][2],
            brackets[2][1] .. brackets[2][2],
            brackets[3][1] .. brackets[3][2]
          }, pair)
        end)
        :with_move(cond.none())
        :with_cr(cond.none())
    -- We only want to delete the pair of spaces when the cursor is as such: ( | )
        :with_del(function(opts)
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local context = opts.line:sub(col - 1, col + 2)
          return vim.tbl_contains({
            brackets[1][1] .. "  " .. brackets[1][2],
            brackets[2][1] .. "  " .. brackets[2][2],
            brackets[3][1] .. "  " .. brackets[3][2]
          }, context)
        end)
  })
end

local function brackets_rules(bracket)
  local npairs = require("nvim-autopairs")
  local Rule = require("nvim-autopairs.rule")
  local cond = require("nvim-autopairs.conds")
  npairs.add_rules({
    -- Each of these rules is for a pair with left-side "( " and right-side " )" for each bracket type
    Rule(bracket[1] .. " ", " " .. bracket[2])
        :with_pair(cond.none())
        :with_move(function(opts) return opts.char == bracket[2] end)
        :with_del(cond.none())
        :use_key(bracket[2])
    -- Removes the trailing whitespace that can occur without this
        :replace_map_cr(function(_) return "<C-c>2xi<CR><C-c>O" end)
  })
end

return {
  enabled = true,
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
    map_cr = true,
    ignored_next_char = [=[[*%w%%%'%[%"%.%`%$]]=],
    enable_afterquote = false,
    fast_wrap = {
      map = '<M-e>',
      chars = { '{', '[', '(', '"', "'" },
      pattern = [=[[%'%"%>%]%)%}%,]]=],
      end_key = '$',
      before_key = 'h',
      after_key = 'l',
      cursor_pos_before = true,
      keys = 'qwertyuiopzxcvbnmasdfghjkl',
      manual_position = true,
      highlight = 'Search',
      highlight_grey='Comment'
    },
  },
  config = function(_, opts)
    require("nvim-autopairs").setup(opts)
    quotes_rules()
    for _, bracket in pairs(brackets) do
      brackets_rules(bracket)
    end
  end
}
