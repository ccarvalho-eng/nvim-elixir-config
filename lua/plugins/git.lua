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
      {
        "<leader>ghs",
        "<cmd>Gitsigns stage_hunk<cr>",
        mode = { "n", "v" },
        desc = "Stage hunk (toggles)",
      },
      { "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", mode = { "n", "v" }, desc = "Reset hunk" },
      { "<leader>ghS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage buffer" },
      { "<leader>ghR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset buffer" },
      { "<leader>ghp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
      { "<leader>ghi", "<cmd>Gitsigns preview_hunk_inline<cr>", desc = "Preview hunk inline" },
      { "<leader>ghb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line" },
      { "<leader>ghd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff against index" },
      {
        "<leader>ghD",
        function()
          require("gitsigns").diffthis("~")
        end,
        desc = "Diff against last commit",
      },
      { "<leader>ghw", "<cmd>Gitsigns toggle_word_diff<cr>", desc = "Toggle word diff" },
      { "<leader>ghq", "<cmd>Gitsigns setqflist<cr>", desc = "Buffer hunks to quickfix" },
      { "<leader>ghQ", "<cmd>Gitsigns setqflist all<cr>", desc = "All hunks to quickfix" },
      { "<leader>ghl", "<cmd>Gitsigns setloclist<cr>", desc = "Buffer hunks to location list" },
      { "<leader>gbb", "<cmd>Gitsigns blame<cr>", desc = "Blame file" },
      {
        "<leader>gbl",
        "<cmd>Gitsigns toggle_current_line_blame<cr>",
        desc = "Toggle inline blame",
      },
      {
        "]h",
        function()
          require("gitsigns").nav_hunk("next")
        end,
        desc = "Next hunk",
      },
      {
        "[h",
        function()
          require("gitsigns").nav_hunk("prev")
        end,
        desc = "Previous hunk",
      },
      {
        "]H",
        function()
          require("gitsigns").nav_hunk("last")
        end,
        desc = "Last hunk",
      },
      {
        "[H",
        function()
          require("gitsigns").nav_hunk("first")
        end,
        desc = "First hunk",
      },
      { "ih", "<cmd>Gitsigns select_hunk<cr>", mode = { "o", "x" }, desc = "Select hunk" },
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
      { "<leader>gG", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit for current file's repo" },
      { "<leader>gL", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit log for current file" },
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
      { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Open diff view" },
      {
        "<leader>gdm",
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
      { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
      { "<leader>gdf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      { "<leader>gdr", "<cmd>DiffviewFileHistory<cr>", desc = "Repository history" },
      { "<leader>gdv", ":DiffviewFileHistory<cr>", mode = "v", desc = "History for selection" },
      { "<leader>gdh", "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Diff against last commit" },
      { "<leader>gdt", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle file panel" },
      { "<leader>gdF", "<cmd>DiffviewFocusFiles<cr>", desc = "Focus file panel" },
    },
  },

  -- Open or copy a permalink for the current file or selection
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>glo",
        function()
          Snacks.gitbrowse({ what = "permalink" })
        end,
        mode = { "n", "v" },
        desc = "Open Git permalink",
      },
      {
        "<leader>gly",
        function()
          Snacks.gitbrowse({
            what = "permalink",
            notify = false,
            open = function(url)
              vim.fn.setreg("+", url)
              vim.notify(url, vim.log.levels.INFO, { title = "Copied Git permalink" })
            end,
          })
        end,
        mode = { "n", "v" },
        desc = "Copy Git permalink",
      },
    },
  },
}
