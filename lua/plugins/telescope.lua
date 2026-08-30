return {
  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-project.nvim",
    },
    cmd = "Telescope",
    config = function()
      local projects_root = vim.fn.expand("~/Projects")
      local worktrees_root = vim.fs.normalize(projects_root .. "/.worktrees")

      local function project_base_dirs()
        local dirs = {}
        local handle = vim.loop.fs_scandir(projects_root)

        if not handle then
          return dirs
        end

        while true do
          local name, kind = vim.loop.fs_scandir_next(handle)

          if not name then
            break
          end

          if kind == "directory" and name ~= ".worktrees" then
            table.insert(dirs, {
              path = projects_root .. "/" .. name,
              max_depth = 3,
            })
          end
        end

        table.sort(dirs, function(left, right)
          return left.path < right.path
        end)

        return dirs
      end

      local function prune_worktree_projects()
        local projects_file = vim.fn.stdpath("data") .. "/telescope-projects.txt"

        if vim.fn.filereadable(projects_file) ~= 1 then
          return
        end

        local lines = vim.fn.readfile(projects_file)
        local kept = {}
        local changed = false

        for _, line in ipairs(lines) do
          local normalized = vim.fs.normalize(line)

          if normalized:find(worktrees_root, 1, true) then
            changed = true
          else
            table.insert(kept, line)
          end
        end

        if changed then
          vim.fn.writefile(kept, projects_file)
        end
      end

      prune_worktree_projects()

      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
        extensions = {
          project = {
            base_dirs = project_base_dirs(),
            ignore_missing_dirs = true,
            hidden_files = false,
            order_by = "recent",
            search_by = "title",
            on_project_selected = function(prompt_bufnr)
              local project_actions = require("telescope._extensions.project.actions")
              project_actions.change_working_directory(prompt_bufnr, false)

              require("nvim-tree.api").tree.change_root(vim.fn.getcwd())
            end,
          },
        },
      })

      require("telescope").load_extension("project")
    end,
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fp", "<cmd>Telescope project<cr>", desc = "Find projects" },
    },
  },

  -- Search and replace
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    config = function()
      require("grug-far").setup({})
    end,
    keys = {
      {
        "<leader>sr",
        function()
          require("grug-far").open()
        end,
        desc = "Replace in project",
      },
      {
        "<leader>sf",
        function()
          require("grug-far").open({
            prefills = {
              paths = vim.fn.expand("%"),
            },
          })
        end,
        desc = "Replace in file",
      },
      {
        "<leader>si",
        function()
          require("grug-far").open({ visualSelectionUsage = "auto-detect" })
        end,
        mode = { "n", "x" },
        desc = "Replace in selection",
      },
    },
  },
}
