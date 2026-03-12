local enabled = vim.env.DEEPSEEK_API_KEY ~= nil

---@type LazySpec
return {
  {
    "milanglacier/minuet-ai.nvim",
    config = true,
    enabled = enabled,
    opts = {
      cmp = { enable_auto_complete = false },
      blink = { enable_auto_complete = false },
      lsp = {
        completion = { enable = false },
        inline_completion = { enable = false },
      },
      context_window = 2000000, -- 1M / 0.5 (In DeepSeek, 1 en ch. ≈ 0.2, 1 zh ch. ≈ 0.6)
      duet = {
        provider = "openai_compatible",
        provider_options = {
          openai_compatible = {
            name = "DeepSeek",
            model = "deepseek-v4-flash",
            end_point = "https://api.deepseek.com/chat/completions",
            api_key = "DEEPSEEK_API_KEY",
            stream = true,
            optional = {
              max_tokens = 256,
              top_p = 0.9,
            },
          },
        },
      },
      provider = "openai_fim_compatible",
      provider_options = {
        openai_fim_compatible = {
          name = "DeepSeek",
          model = "deepseek-v4-flash",
          end_point = "https://api.deepseek.com/beta/completions",
          api_key = "DEEPSEEK_API_KEY",
          stream = true,
          optional = {
            reasoning_effort = "low",
            max_tokens = 4000, -- as in DeepSeek FIM doc
            -- top_p = 0.9,
          },
        },
      },
    },
    cmd = { "Minuet" },
    keys = {
      { "<leader>mp", "<cmd>Minuet duet predict<cr>", mode = { "n" }, desc = "Minuet duet predict" },
      { "<leader>ma", "<cmd>Minuet duet apply<cr>", mode = { "n" }, desc = "Minuet duet apply" },
      { "<leader>md", "<cmd>Minuet duet dismiss<cr>", mode = { "n" }, desc = "Minuet duet dismiss" },
      { "<M-z>", "<cmd>Minuet duet predict<cr>", mode = { "i" }, desc = "Minuet duet predict" },
      { "<M-a>", "<cmd>Minuet duet apply<cr>", mode = { "i" }, desc = "Minuet duet apply" },
      { "<M-x>", "<cmd>Minuet duet dismiss<cr>", mode = { "i" }, desc = "Minuet duet dismiss" },
    },
  },
}
