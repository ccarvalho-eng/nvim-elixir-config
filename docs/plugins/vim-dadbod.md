# `vim-dadbod`

Connects Neovim to databases through native database clients.

- Configuration: [`db.lua`](../../lua/plugins/db.lua)

## Installation

1. Run `:Lazy sync` to install the Neovim plugin.
2. System dependency: Install the client for each database. For PostgreSQL: `brew install libpq` and add its `bin` directory to `PATH`; macOS includes `sqlite3`.

## Use

Set database URLs through environment variables, then use `:DB` commands. Never commit credentials.

