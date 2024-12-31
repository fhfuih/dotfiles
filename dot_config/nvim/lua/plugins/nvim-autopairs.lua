return {
  "windwp/nvim-autopairs",
  config = function(plugin, opts)
    require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts)
    local Rule = require "nvim-autopairs.rule"
    local npairs = require "nvim-autopairs"
    local cond = require "nvim-autopairs.conds"

    -- Change tex backtick
    for _, backtick_rules in ipairs(npairs.get_rules "`") do
      backtick_rules.not_filetypes = { "tex", "latex" }
    end
    npairs.add_rules {
      Rule("`", "'", { "tex", "latex" }),
      Rule("\\(", "\\)", { "tex", "latex" }),
      Rule("\\[", "\\]", { "tex", "latex" }),
    }

    -- tex math surroundings
  end,
}
