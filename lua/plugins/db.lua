return {
  -- Database client. Drives the psql/mysql/sqlite binaries directly rather
  -- than a plugin-specific daemon, and dadbod-completion feeds table and
  -- column names into the existing nvim-cmp setup.
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer", "DB" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 30
      vim.g.db_ui_use_postgres_views = 1

      -- Default is 1, which fires the query on every :w. Keep running a query
      -- an explicit act so saving a scratch buffer cannot hit the database.
      vim.g.db_ui_execute_on_save = 0
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserDadbodCompletion", { clear = true }),
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          pcall(function()
            require("cmp").setup.buffer({
              sources = { { name = "vim-dadbod-completion" } },
            })
          end)
        end,
      })
    end,
    keys = {
      { "<leader>du", "<cmd>DBUIToggle<cr>", desc = "Toggle database UI" },
      { "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "Find database buffer" },
      { "<leader>da", "<cmd>DBUIAddConnection<cr>", desc = "Add connection" },
      { "<leader>dr", "<Plug>(DBUI_ExecuteQuery)", desc = "Run query" },
      { "<leader>dr", "<Plug>(DBUI_ExecuteQuery)", mode = "v", desc = "Run selected query" },
      { "<leader>dS", "<Plug>(DBUI_SaveQuery)", desc = "Save query" },
    },
  },
}
