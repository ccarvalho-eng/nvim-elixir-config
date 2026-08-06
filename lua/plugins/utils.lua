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
        -- No wait on the localleader: plugin buffers (octo) are the only thing
        -- bound there, so show the menu the moment it is pressed.
        delay = function(ctx)
          return ctx.keys == vim.g.maplocalleader and 0 or 300
        end,
      })

      -- Register key group names
      wk.add({
        { "<leader>a", group = "AI" },
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code/LSP" },
        { "<leader>f", group = "Find/Telescope" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "GitHub" },
        { "<leader>o", group = "Obsidian" },
        { "<leader>s", group = "Search/Shell" },
        { "<leader>t", group = "Test" },
        { "<leader>u", group = "UI" },
      })
    end,
  },
}
