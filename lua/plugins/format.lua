return {
  -- Formatting for filetypes no attached LSP server handles. Elixir is left to
  -- dexter, which already formats on save; this covers the Lua in this repo.
  --
  -- Deliberately manual: the existing Lua files predate stylua, so formatting
  -- on save would mix reformatting into unrelated commits.
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format with conform",
      },
    },
  },
}
