-- Neovim Configuration for Elixir Development

-- Load core configuration
require("config.compat")
require("config.options")
require("config.lazy")
require("config.worktree").setup()
require("config.octo_help").setup()
require("config.keymaps")
