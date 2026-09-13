return {
  -- Elixir syntax highlighting (vim-elixir)
  {
    "elixir-editors/vim-elixir",
    ft = { "elixir", "eelixir", "heex", "surface" },
  },

  -- Keep normal notifications in Snacks; Fidget only renders LSP progress.
  {
    "j-hui/fidget.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      progress = {
        suppress_on_insert = true,
      },
      notification = {
        override_vim_notify = false,
        window = {
          winblend = 10,
        },
      },
    },
  },
}
