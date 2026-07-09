return {
  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      })
    end,
    keys = {
      { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Git blame line" },
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
      { "<leader>gh", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk" },
    },
  },

  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  -- Open file/line on GitHub
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitlinker").setup({
        opts = {
          add_current_line_on_normal_mode = true,
          action_callback = require("gitlinker.actions").copy_to_clipboard,
          print_url = true,
        },
        mappings = nil,
      })
    end,
    keys = {
      { "<leader>gy", "<cmd>lua require('gitlinker').get_buf_range_url('n')<cr>", desc = "Copy GitHub link" },
      { "<leader>gy", "<cmd>lua require('gitlinker').get_buf_range_url('v')<cr>", mode = "v", desc = "Copy GitHub link (selection)" },
    },
  },
}
