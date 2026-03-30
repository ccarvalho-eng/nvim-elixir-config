return {
  -- Snacks (terminal provider for Claude Code)
  {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
      dashboard = { enabled = false },
    },
  },

  -- Claude Code integration
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      require("claudecode").setup({
        terminal = {
          split_side = "right",
          split_width_percentage = 0.35,
          git_repo_cwd = true,
          provider = "snacks",
        },
        selection = {
          track_selection = true,
          focus_after_send = true,
        },
        diff_opts = {
          layout = "horizontal", -- "vertical" or "horizontal"
          open_in_new_tab = false,
          keep_terminal_focus = false, -- If true, moves focus back to terminal after diff opens
          hide_terminal_in_new_tab = false,
          -- on_new_file_reject = "keep_empty", -- "keep_empty" or "close_window"

          -- Legacy aliases (still supported):
          -- vertical_split = true,
          -- open_in_current_tab = true,
        },
      })
    end,
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude Code" },
      { "<leader>ar", "<cmd>ClaudeCode resume<cr>", desc = "Resume Claude session" },
      { "<leader>aC", "<cmd>ClaudeCode continue<cr>", desc = "Continue Claude session" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer to Claude" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject Claude diff" },
    },
  },
}
