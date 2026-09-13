# Neovim dependencies

External tools used by this configuration. Lazy.nvim installs the Neovim plugins themselves.

## 1. Prerequisites

Install [Homebrew](https://brew.sh), then install the Xcode command-line tools:

```shell
xcode-select --install
```

This supplies Git, Make, and a C compiler. Lazy.nvim needs Git to download plugins, while Tree-sitter needs the build tools to compile parsers.

## 2. Required tools

```shell
brew install neovim ripgrep fd tree-sitter-cli lazygit stylua lua-language-server
brew install --cask font-fira-code-nerd-font
```

| Tool | Why it is needed | Used by |
| --- | --- | --- |
| `neovim` 0.12 or newer | Runs this configuration | The editor and nvim-treesitter |
| `ripgrep` (`rg`) | Fast project text search | Telescope, Grug Far, Obsidian |
| `fd` | Fast file discovery | Telescope |
| `tree-sitter-cli` | Installs and updates syntax parsers | nvim-treesitter |
| `lazygit` | Interactive Git interface | Snacks |
| `stylua` | Formats Lua files | conform.nvim |
| `lua-language-server` | Lua diagnostics, navigation, and completion | Neovim LSP and nvim-cmp |
| Nerd Font | Supplies the icons used by the interface | Bufferline, Lualine, nvim-tree, devicons |

Tree-sitter also uses the compiler, `curl`, and `tar` supplied by macOS and the command-line tools. Use Tree-sitter CLI 0.26.1 or newer and ripgrep 14 or newer.

## 3. Dexter

Dexter provides Elixir language-server features when `dexter` is available. Install it only if needed:

```shell
brew install asdf
asdf plugin add dexter https://github.com/remoteoss/dexter.git
asdf install dexter 0.7.1
asdf set --home dexter 0.7.1
dexter version
```

Elixir and Erlang installation is intentionally not covered here.

## 4. Local AI

Pi, Ollama, and Ketch are required only for the local AI integration:

```shell
brew install --cask ollama-app
brew install 1broseidon/tap/ketch
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```

Follow [Pi with Ollama](pi-ollama.md) to install the models and configure their short aliases.

Codex and Claude are separate, optional integrations:

- Codex: follow the [Codex CLI installation guide](https://learn.chatgpt.com/docs/codex/cli).
- Claude: run `npm install -g @anthropic-ai/claude-code`.

## 5. Optional integrations

Install only what you use.

| Feature | Installation | Why it is needed |
| --- | --- | --- |
| Docker | Docker Desktop and `brew install lazydocker` | Runs containers and lets Snacks open LazyDocker |
| PostgreSQL | `brew install libpq`, then put its `bin` directory on `PATH` | Lets Dadbod and the PostgreSQL terminal run `psql` |
| MySQL | `brew install mysql-client`, then put its `bin` directory on `PATH` | Lets Dadbod connect through the MySQL client |
| SQLite | `sqlite3` is included with macOS | Lets Dadbod open SQLite databases |
| Gleam | `brew install gleam` | Enables the configured Gleam language server |
| Obsidian | Obsidian app, `ripgrep`, and `OBSIDIAN_VAULT` | Opens the vault, searches notes, and launches the desktop app |
| Tests | The current project's test runner | Allows vim-test to execute tests |

Set the Obsidian vault without committing a machine-specific path:

```shell
export OBSIDIAN_VAULT="/path/to/vault"
```

Keep database credentials in environment variables, not in this repository.

## 6. Install and verify Neovim plugins

Start Neovim and run:

```vim
:Lazy sync
:checkhealth
```

Useful feature checks:

```vim
:ConformInfo
:checkhealth snacks
:Obsidian check
```

Plugins not represented above are implemented in Lua and need no separate system installation.
