local function toggle_ai_agent()
  local choices = {
    c = function()
      vim.cmd.ClaudeCode()
    end,
    C = function()
      require("codex").toggle()
    end,
    p = function()
      vim.cmd("Pi layout=side")
    end,
  }

  local lines = {
    " c  Claude Code",
    " C  Codex",
    " p  Pi",
  }
  local width = 0

  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end

  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)

  local window = vim.api.nvim_open_win(buffer, true, {
    relative = "editor",
    width = width,
    height = #lines,
    row = math.floor((vim.o.lines - #lines) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " AI agent ",
    title_pos = "center",
  })

  for index = 0, #lines - 1 do
    vim.api.nvim_buf_add_highlight(buffer, -1, "Special", index, 1, 2)
  end

  local ok, key = pcall(vim.fn.getcharstr)

  if vim.api.nvim_win_is_valid(window) then
    vim.api.nvim_win_close(window, true)
  end

  if ok and choices[key] then
    vim.schedule(choices[key])
  end
end

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
      -- Codex actions are bound explicitly under <leader>ao* below.
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
        "<F9>",
        toggle_ai_agent,
        desc = "Toggle AI agent",
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
        "<leader>apf",
        "<cmd>Pi layout=float<cr>",
        desc = "Open Pi float",
        mode = { "n", "v" },
      },
      {
        "<leader>apc",
        "<cmd>PiContinue<cr>",
        desc = "Continue Pi session",
        mode = { "n", "v" },
      },
      {
        "<leader>apr",
        "<cmd>PiResume<cr>",
        desc = "Resume Pi session",
        mode = { "n", "v" },
      },
      {
        "<leader>apm",
        "<cmd>PiSelectModel<cr>",
        desc = "Select Pi model",
      },
      {
        "<leader>aps",
        "<cmd>PiSendMention<cr>",
        desc = "Send selection to Pi",
        mode = { "n", "v" },
      },
      {
        "<leader>apa",
        "<cmd>PiAttention<cr>",
        desc = "Open Pi attention request",
      },
      {
        "<leader>apx",
        "<cmd>PiAbort<cr>",
        desc = "Abort Pi operation",
      },
    },
  },
}
