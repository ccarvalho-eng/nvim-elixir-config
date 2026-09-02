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
      -- Named connections, so a URL never has to be typed or remembered.
      -- Credentials come from the same POSTGRES_* variables the project .envrc
      -- files export; this repo is public, so nothing is hardcoded here.
      -- dadbod-ui also picks up $DBUI_URL on its own when one is set.
      local function pg(database)
        local password = vim.uri_encode(vim.env.POSTGRES_PASSWORD or "postgres", "rfc2396")

        return string.format(
          "postgres://%s:%s@%s:%s/%s",
          vim.env.POSTGRES_USERNAME or "postgres",
          password,
          vim.env.PGHOST or "localhost",
          vim.env.PGPORT or "5432",
          database
        )
      end

      -- Local *_prod databases exist too, but are left out on purpose: a
      -- connection labelled prod in the drawer is an accident waiting to
      -- happen. Reach for those through :DB when actually needed.
      vim.g.dbs = {
        axle_pay = pg("axle_pay_dev"),
        axle_pay_eventstore = pg("axle_pay_eventstore_dev"),
        axle_pay_test = pg("axle_pay_test"),
        axle_pay_eventstore_test = pg("axle_pay_eventstore_test"),
      }

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

  -- An interactive psql session, for the exploratory work a query buffer is
  -- bad at: \d, tab completion of relation names, \x, transaction state.
  -- Picks from the same vim.g.dbs connections the drawer uses.
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>dp",
        function()
          local connections = vim.g.dbs or {}
          local names = vim.tbl_keys(connections)

          if vim.tbl_isempty(names) then
            vim.notify("No connections defined in vim.g.dbs", vim.log.levels.WARN)
            return
          end

          table.sort(names)

          vim.ui.select(names, { prompt = "psql connection" }, function(choice)
            if not choice then
              return
            end

            -- Hand psql the password through the environment rather than the
            -- URL, so it does not show up in the process list.
            local url = connections[choice]
            local password = url:match("^postgres://[^:]+:([^@]*)@")

            Snacks.terminal({ "psql", (url:gsub("(://[^:]+):[^@]*@", "%1@")) }, {
              env = password and { PGPASSWORD = vim.uri_decode(password) } or nil,
              win = {
                position = "bottom",
                height = 0.4,
              },
            })
          end)
        end,
        desc = "psql session",
      },
    },
  },
}
