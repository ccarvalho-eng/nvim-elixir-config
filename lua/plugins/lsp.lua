return {
  -- Elixir syntax highlighting (vim-elixir)
  {
    "elixir-editors/vim-elixir",
    ft = { "elixir", "eelixir", "heex", "surface" },
  },

  -- Preview LSP locations in floating windows without leaving the current buffer.
  {
    "rmagatti/goto-preview",
    dependencies = {
      "rmagatti/logger.nvim",
    },
    keys = {
      {
        "gpd",
        function()
          require("goto-preview").goto_preview_definition()
        end,
        desc = "Preview definition",
      },
      {
        "gpt",
        function()
          require("goto-preview").goto_preview_type_definition()
        end,
        desc = "Preview type definition",
      },
      {
        "gpi",
        function()
          require("goto-preview").goto_preview_implementation()
        end,
        desc = "Preview implementation",
      },
      {
        "gpD",
        function()
          require("goto-preview").goto_preview_declaration()
        end,
        desc = "Preview declaration",
      },
      {
        "gpr",
        function()
          require("goto-preview").goto_preview_references()
        end,
        desc = "Preview references",
      },
      {
        "gpc",
        function()
          require("goto-preview").close_all_win()
        end,
        desc = "Close preview windows",
      },
    },
    opts = {
      references = {
        provider = "telescope",
      },
    },
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
