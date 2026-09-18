return {
  -- Plenary (required by many plugins)
  {
    "nvim-lua/plenary.nvim",
  },

  -- which-key for keybinding hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      preset = "modern",
      delay = 300,
      -- BufferLine's numeric jumps and move mappings are 13 of the 24 Buffer
      -- entries and bury the rest. They keep working; which-key just hides them.
      filter = function(mapping)
        return not mapping.lhs:match("^%sb[%d<>]$")
      end,
      -- Group names without an icon fall back to which-key's built-in rules,
      -- which already cover AI, Buffer, Code, Find, Git, Search, and Diagnostics.
      spec = {
        { "<leader>a", group = "AI" },
        { "<leader>ao", group = "OpenCode" },
        { "<leader>b", group = "Buffer" },
        { "<leader>bs", group = "Sort", icon = { icon = "", color = "cyan" } },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>gb", group = "Blame", icon = { icon = "", color = "orange" } },
        { "<leader>gd", group = "Diff", icon = { icon = "", color = "orange" } },
        { "<leader>gh", group = "Hunks", icon = { icon = "", color = "orange" } },
        { "<leader>gl", group = "Links", icon = { icon = "", color = "blue" } },
        { "<leader>gw", group = "Worktrees", icon = { icon = "", color = "purple" } },
        { "<leader>n", group = "News", icon = { icon = "", color = "orange" } },
        { "<leader>o", group = "Notes", icon = { icon = "", color = "purple" } },
        { "<leader>s", group = "Search/Replace" },
        { "<leader>t", group = "Tests", icon = { icon = "", color = "green" } },
        { "<leader>u", group = "Utilities", icon = { icon = "", color = "grey" } },
        { "<leader>x", group = "Diagnostics" },
        { "gp", group = "Preview", icon = { icon = "", color = "azure" } },
      },
    },
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },
}
