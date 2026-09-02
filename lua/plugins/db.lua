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
      vim.g.db_ui_winwidth = 35
      vim.g.db_ui_use_postgres_views = 1

      -- The drawer help block is a permanent 10-line banner; ? toggles it back.
      vim.g.db_ui_show_help = 0

      -- Results open in the preview window, so previewheight is what sizes
      -- them. The default 12 lines shows very few rows. This is a global
      -- option, so it also applies to any other :pedit preview.
      vim.o.previewheight = math.max(15, math.floor(vim.o.lines * 0.4))

      -- Route dadbod's messages through vim.notify, which snacks.notifier owns,
      -- instead of the cmdline where noice already shows other traffic.
      vim.g.db_ui_use_nvim_notify = 1

      -- Postgres internals are never the thing being inspected.
      vim.g.db_ui_hide_schemas = { "pg_catalog", "pg_toast", "information_schema" }

      -- Merged into the built-in helpers, which already cover List, Indexes,
      -- Foreign Keys, References and Primary Keys. Columns is overridden
      -- because the default selects all 44 information_schema fields.
      vim.g.db_ui_table_helpers = {
        postgresql = {
          Count = 'select count(*) as rows from {optional_schema}"{table}"',
          Columns = "select column_name, data_type, is_nullable, column_default"
            .. " from information_schema.columns"
            .. " where table_name='{table}' and table_schema='{schema}'"
            .. " order by ordinal_position",
          Size = "select pg_size_pretty(pg_total_relation_size('{schema}.{table}')) as total,"
            .. " pg_size_pretty(pg_relation_size('{schema}.{table}')) as table_only",
        },
      }

      -- Default is 1, which fires the query on every :w. Keep running a query
      -- an explicit act so saving a scratch buffer cannot hit the database.
      vim.g.db_ui_execute_on_save = 0
    end,
    config = function()
      -- The drawer is created with `nonumber norelativenumber`, so this has to
      -- run after it, on the FileType the plugin sets straight afterwards.
      -- Hybrid numbering, matching the nvim-tree view.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserDadbodDrawer", { clear = true }),
        pattern = "dbui",
        callback = function()
          vim.opt_local.number = true
          vim.opt_local.relativenumber = true
        end,
      })

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
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>dp",
        function()
          vim.ui.input({
            prompt = "psql URL: ",
            default = "postgres://postgres@localhost:5432/",
          }, function(url)
            if not url or vim.trim(url) == "" then
              return
            end

            Snacks.terminal({ "psql", vim.trim(url) }, {
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
