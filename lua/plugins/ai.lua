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
      -- Codex is bound explicitly under <leader>ao* below.
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
        "<leader>aot",
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
        "<leader>aoo",
        function()
          require("codex.terminal").open()
        end,
        desc = "Open Codex",
      },
      {
        "<leader>aof",
        function()
          require("codex.terminal").focus_toggle()
        end,
        desc = "Focus Codex",
      },
      {
        "<leader>aos",
        function()
          require("codex").actions.send_selection()
        end,
        desc = "Send selection to Codex",
        mode = "v",
      },
      {
        "<leader>aom",
        "<cmd>CodexMaximizeToggle<cr>",
        desc = "Toggle Codex maximize",
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
        "<leader>act",
        "<cmd>ClaudeCode<cr>",
        desc = "Toggle Claude",
      },
      {
        "<leader>acf",
        "<cmd>ClaudeCodeFocus<cr>",
        desc = "Focus Claude",
      },
      {
        "<leader>acr",
        "<cmd>ClaudeCode --resume<cr>",
        desc = "Resume Claude",
      },
      {
        "<leader>acc",
        "<cmd>ClaudeCode --continue<cr>",
        desc = "Continue Claude",
      },
      {
        "<leader>acm",
        "<cmd>ClaudeCodeSelectModel<cr>",
        desc = "Select Claude model",
      },
      {
        "<leader>acb",
        "<cmd>ClaudeCodeAdd %<cr>",
        desc = "Add current buffer to Claude",
      },
      {
        "<leader>acs",
        "<cmd>ClaudeCodeSend<cr>",
        desc = "Send selection to Claude",
        mode = "v",
      },
      {
        "<leader>aca",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file to Claude",
        ft = "NvimTree",
      },
      {
        "<leader>acy",
        "<cmd>ClaudeCodeDiffAccept<cr>",
        desc = "Accept Claude diff",
      },
      {
        "<leader>acn",
        "<cmd>ClaudeCodeDiffDeny<cr>",
        desc = "Deny Claude diff",
      },
      {
        "<leader>acx",
        "<cmd>ClaudeCodeCloseAllDiffs<cr>",
        desc = "Close all Claude diffs",
      },
      {
        "<leader>aci",
        "<cmd>ClaudeCodeStatus<cr>",
        desc = "Claude connection status",
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
      -- (obsidian). Scope every opencode keymap under the AI group instead,
      -- matching <leader>ac (Claude) and <leader>ao (Codex).
      keymap_prefix = "<leader>ap",
      preferred_picker = "telescope",
      keymap = {
        editor = {
          ["<leader>apm"] = { "configure_provider", desc = "Select OpenCode model" },
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

  {
    "alex35mil/pi.nvim",
    cmd = {
      "Pi",
      "PiAbort",
      "PiAttention",
      "PiContinue",
      "PiResume",
      "PiSelectModel",
      "PiSendMention",
      "PiStop",
      "PiToggleChat",
      "PiToggleLayout",
    },
    opts = {
      models = {
        "qwen3-coder:deep",
        "qwen2.5-coder:fast",
        "mistral-small3.2:writing",
      },
      layout = {
        default = "side",
        side = {
          position = "right",
          width = 80,
        },
      },
    },
    keys = {
      {
        "<leader>ait",
        function()
          require("pi").toggle({ layout = "side" })
        end,
        desc = "Toggle Pi",
        mode = { "n", "v" },
      },
      {
        "<leader>aif",
        "<cmd>Pi layout=float<cr>",
        desc = "Open Pi float",
        mode = { "n", "v" },
      },
      {
        "<leader>aic",
        "<cmd>PiContinue<cr>",
        desc = "Continue Pi session",
        mode = { "n", "v" },
      },
      {
        "<leader>air",
        "<cmd>PiResume<cr>",
        desc = "Resume Pi session",
        mode = { "n", "v" },
      },
      {
        "<leader>aim",
        "<cmd>PiSelectModel<cr>",
        desc = "Select Pi model",
      },
      {
        "<leader>ais",
        "<cmd>PiSendMention<cr>",
        desc = "Send selection to Pi",
        mode = { "n", "v" },
      },
      {
        "<leader>aia",
        "<cmd>PiAttention<cr>",
        desc = "Open Pi attention request",
      },
      {
        "<leader>aix",
        "<cmd>PiAbort<cr>",
        desc = "Abort Pi operation",
      },
    },
  },
}
