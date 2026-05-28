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

  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeAdd",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
    },
    opts = {
      terminal_cmd = vim.fn.exepath("claude") ~= "" and vim.fn.exepath("claude") or "claude",
      terminal = {
        provider = "snacks",
        split_side = "right",
        split_width_percentage = 0.35,
      },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)
    end,
    keys = {
      {
        "<leader>ac",
        "<cmd>ClaudeCode<cr>",
        desc = "Toggle Claude",
      },
      {
        "<leader>af",
        "<cmd>ClaudeCodeFocus<cr>",
        desc = "Focus Claude",
      },
      {
        "<leader>ar",
        "<cmd>ClaudeCode --resume<cr>",
        desc = "Resume Claude",
      },
      {
        "<leader>aR",
        "<cmd>ClaudeCode --continue<cr>",
        desc = "Continue Claude",
      },
      {
        "<leader>am",
        "<cmd>ClaudeCodeSelectModel<cr>",
        desc = "Select Claude model",
      },
      {
        "<leader>ab",
        "<cmd>ClaudeCodeAdd %<cr>",
        desc = "Add current buffer to Claude",
      },
      {
        "<leader>aS",
        "<cmd>ClaudeCodeSend<cr>",
        desc = "Send selection to Claude",
        mode = "v",
      },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file to Claude",
        ft = "NvimTree",
      },
      {
        "<leader>aa",
        "<cmd>ClaudeCodeDiffAccept<cr>",
        desc = "Accept Claude diff",
      },
      {
        "<leader>ad",
        "<cmd>ClaudeCodeDiffDeny<cr>",
        desc = "Deny Claude diff",
      },
    },
  },
}
