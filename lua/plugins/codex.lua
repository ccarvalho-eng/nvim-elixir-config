return {
  {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      input = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      words = { enabled = true },
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
      status_indicator = {
        enabled = false,
      },
      terminal = {
        provider = "snacks",
        split_side = "right",
        split_width_percentage = 0.35,
      },
    },
    config = function(_, opts)
      require("codex").setup(opts)
    end,
    keys = {
      {
        "<leader>aC",
        function()
          require("codex").toggle()
        end,
        desc = "Toggle Codex",
      },
      {
        "<F9>",
        function()
          require("codex").toggle()
        end,
        desc = "Toggle Codex",
        mode = { "n", "t" },
      },
      {
        "<leader>ao",
        function()
          require("codex.terminal").open()
        end,
        desc = "Open Codex",
      },
      {
        "<leader>aq",
        function()
          require("codex.terminal").focus_toggle()
        end,
        desc = "Focus Codex",
      },
      {
        "<leader>as",
        function()
          require("codex").actions.send_selection()
        end,
        desc = "Send selection to Codex",
        mode = "v",
      },
    },
  },
}
