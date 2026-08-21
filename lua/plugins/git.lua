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
          local function git(...)
            local output = vim.fn.systemlist({ "git", ... })

            if vim.v.shell_error ~= 0 then
              return nil
            end

            return output[1]
          end

          local branch = git("branch", "--show-current")

          if branch == nil or branch == "" then
            vim.notify("Unable to resolve current git branch", vim.log.levels.WARN)
            return
          end

          -- Ask the remote what its default branch is before falling back to the
          -- conventional names, so repositories on master/develop still diff.
          local default = git("symbolic-ref", "--short", "refs/remotes/origin/HEAD")

          if default == nil or default == "" then
            for _, candidate in ipairs({ "origin/main", "origin/master" }) do
              if git("rev-parse", "--verify", "--quiet", candidate) then
                default = candidate
                break
              end
            end
          end

          if default == nil or default == "" then
            vim.notify("Unable to resolve the default branch for origin", vim.log.levels.WARN)
            return
          end

          vim.cmd("DiffviewOpen " .. vim.fn.fnameescape(default .. "..." .. branch))
        end,
        desc = "Diff current branch against the default branch",
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
}
