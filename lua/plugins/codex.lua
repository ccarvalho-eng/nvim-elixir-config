return {
  {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
      dashboard = { enabled = false },
    },
  },

  {
    "johnseth97/codex.nvim",
    cmd = { "Codex", "CodexToggle" },
    opts = {
      keymaps = {
        toggle = nil,
        quit = "<C-q>",
      },
      border = "rounded",
      width = 0.35,
      panel = true,
      autoinstall = false,
    },
    keys = {
      {
        "<leader>ac",
        function()
          require("codex").toggle()
        end,
        desc = "Toggle Codex",
        mode = { "n", "t" },
      },
      { "<leader>ao", "<cmd>Codex<cr>", desc = "Open Codex" },
      { "<leader>aq", "<cmd>CodexToggle<cr>", desc = "Toggle Codex" },
    },
  },
}
