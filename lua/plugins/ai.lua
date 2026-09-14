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
        desc = "Toggle Claude Code",
      },
    },
  },

  {
    "ccarvalho-eng/pi.nvim",
    branch = "ccarvalho/visible-agent-status",
    dependencies = { "hrsh7th/nvim-cmp" },
    cmd = {
      "Pi",
      "PiAbort",
      "PiAttention",
      "PiClear",
      "PiContinue",
      "PiResume",
      "PiSelectModel",
      "PiSendMention",
      "PiStop",
      "PiToggleChat",
      "PiToggleLayout",
    },
    opts = {
      cli = {
        args = {
          "--tools",
          "read,bash,edit,write,grep,find,ls,internet_search,internet_scrape",
        },
      },
      models = {
        "qwen3-coder:deep",
        "qwen2.5-coder:fast",
        "mistral-small3.2:writing",
      },
      layout = {
        default = "side",
        side = {
          position = "right",
          width = 70,
        },
      },
    },
    config = function(_, opts)
      require("pi").setup(opts)

      local cmp = require("cmp")
      cmp.register_source("pi", require("pi.completion.cmp").new())
      cmp.setup.filetype("pi-chat-prompt", {
        sources = { { name = "pi" } },
      })
    end,
    keys = {
      {
        "<leader>ap",
        "<cmd>Pi layout=side<cr>",
        desc = "Toggle Pi",
        mode = { "n", "v" },
      },
    },
  },
}
