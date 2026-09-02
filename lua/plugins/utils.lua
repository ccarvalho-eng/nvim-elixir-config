return {
  -- Plenary (required by many plugins)
  {
    "nvim-lua/plenary.nvim",
  },

  -- which-key for keybinding hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        preset = "modern",
        delay = 300,
      })

      -- Register key group names
      wk.add({
        { "<leader>a", group = "AI" },
        { "<leader>ac", group = "Claude" },
        { "<leader>ao", group = "Codex" },
        { "<leader>b", group = "Buffer" },
        { "<leader>bs", group = "Sort" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Database" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>gb", group = "Blame" },
        { "<leader>gd", group = "Diff" },
        { "<leader>gh", group = "Hunks" },
        { "<leader>gl", group = "Links" },
        { "<leader>gw", group = "Worktrees" },
        { "<leader>o", group = "Notes" },
        { "<leader>s", group = "Search/Replace" },
        { "<leader>t", group = "Tests" },
        { "<leader>u", group = "Utilities" },
        { "<leader>x", group = "Diagnostics" },
      })
    end,
  },
}
