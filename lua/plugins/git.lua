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

  -- Git diff/file history viewer
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open diff view" },
      {
        "<leader>gm",
        function()
          local branch = vim.fn.systemlist({ "git", "branch", "--show-current" })[1]

          if vim.v.shell_error ~= 0 or branch == nil or branch == "" then
            vim.notify("Unable to resolve current git branch", vim.log.levels.WARN)
            return
          end

          vim.cmd("DiffviewOpen " .. vim.fn.fnameescape("origin/main..." .. branch))
        end,
        desc = "Diff current branch against main",
      },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      { "<leader>gF", "<cmd>DiffviewFileHistory<cr>", desc = "Repository history" },
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

  -- GitHub issues and pull requests inside Neovim
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      picker = "telescope",
      enable_builtin = true,
    },
    keys = {
      { "<leader>ha", "<cmd>Octo search is:pr is:open assignee:@me<cr>", desc = "GitHub PRs assigned to me" },
      { "<leader>hi", "<cmd>Octo issue list<cr>", desc = "List GitHub issues" },
      { "<leader>hm", "<cmd>Octo search is:pr is:open author:@me<cr>", desc = "My open GitHub PRs" },
      { "<leader>hp", "<cmd>Octo pr list<cr>", desc = "List GitHub pull requests" },
      { "<leader>hn", "<cmd>Octo notification list<cr>", desc = "List GitHub notifications" },
      { "<leader>hr", "<cmd>Octo search is:pr is:open review-requested:@me<cr>", desc = "GitHub PRs awaiting my review" },
      { "<leader>hs", "<cmd>Octo search<cr>", desc = "Search GitHub" },
      { "<leader>hv", "<cmd>Octo review<cr>", desc = "Review current GitHub PR" },
      {
        "<leader>h?",
        function()
          require("config.octo_help").open()
        end,
        desc = "Octo key reference",
      },
      {
        "<leader>hk",
        function()
          require("which-key").show({ keys = vim.g.maplocalleader, loop = true })
        end,
        desc = "Octo keys in this buffer",
      },
    },
  },
}
