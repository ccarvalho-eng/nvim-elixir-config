return {
  {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
      dashboard = { enabled = false },
    },
  },

  {
    "ishiooon/codex.nvim",
    cmd = {
      "Codex",
      "CodexFocus",
      "CodexSend",
      "CodexTreeAdd",
    },
    opts = {
      env = {
        ENABLE_IDE_INTEGRATION = "true",
      },
      terminal = {
        provider = "snacks",
        direction = "vertical",
        position = "right",
        size = 0.35,
      },
    },
    config = function(_, opts)
      require("codex").setup(opts)
    end,
    keys = {
      {
        "<leader>ac",
        function()
          vim.cmd("Codex")
        end,
        desc = "Toggle Codex",
        mode = { "n", "t" },
      },
      { "<leader>ao", "<cmd>Codex<cr>", desc = "Open Codex" },
      { "<leader>aq", "<cmd>CodexFocus<cr>", desc = "Focus Codex" },
      { "<leader>as", "<cmd>CodexSend<cr>", desc = "Send selection to Codex", mode = "v" },
    },
  },
}
