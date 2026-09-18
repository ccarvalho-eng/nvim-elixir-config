return {
  {
    "ishiooon/codex.nvim",
    cmd = {
      "Codex",
      "CodexFocus",
      "CodexMaximizeToggle",
      "CodexSend",
      "CodexTreeAdd",
    },
    opts = {
      -- Its defaults claim <leader>cc/cf/cm/cs, which collide with the Code
      -- group: cf is the LSP format map and cs is Trouble document symbols.
      -- Codex is bound explicitly below.
      keymaps = false,
      env = {
        ENABLE_IDE_INTEGRATION = "true",
      },
      status_indicator = {
        enabled = false,
      },
      terminal = {
        provider = "snacks",
        split_side = "right",
        split_width_percentage = 0.30,
      },
      diff_opts = {
        layout = "horizontal",
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
        desc = "Codex",
      },
      {
        "<F9>",
        function()
          require("codex").toggle()
        end,
        desc = "Codex",
        mode = { "n", "t" },
      },
    },
  },

  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeAdd",
      "ClaudeCodeCloseAllDiffs",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeSend",
      "ClaudeCodeStatus",
      "ClaudeCodeTreeAdd",
    },
    opts = {
      terminal_cmd = vim.fn.exepath("claude") ~= "" and vim.fn.exepath("claude") or "claude",
      terminal = {
        provider = "snacks",
        split_side = "right",
        split_width_percentage = 0.30,
      },
      diff_opts = {
        layout = "horizontal",
      },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)
    end,
    keys = {
      {
        "<leader>ac",
        "<cmd>ClaudeCode<cr>",
        desc = "Claude Code",
      },
    },
  },

  {
    "sudo-tee/opencode.nvim",
    dependencies = {
      "folke/snacks.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "opencode_output",
        opts = {
          anti_conceal = { enabled = false },
          file_types = { "opencode_output" },
        },
      },
    },
    opts = {
      -- Default prefix is <leader>o, which collides with the Notes group
      -- (obsidian), so scope every opencode keymap under <leader>ao instead.
      keymap_prefix = "<leader>ao",
      preferred_picker = "telescope",
      keymap = {
        editor = {
          ["<leader>aom"] = { "configure_provider", desc = "Select OpenCode model" },
        },
      },
      ui = {
        position = "right",
        window_width = 0.30,
      },
    },
    config = function(_, opts)
      require("opencode").setup(opts)
    end,
  },
}
