-- Neovim Configuration for Elixir Development

-- Load core configuration
require("config.compat")
require("config.options")
require("config.diagnostics")
require("config.lazy")
require("config.lsp")
require("config.worktree").setup()
require("config.keymaps")
