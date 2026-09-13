# Neovim system dependencies

Use this checklist after cloning the Neovim configuration onto a new Mac. Lazy.nvim installs Lua plugins; the tools below must be installed separately.

For installation and usage notes for every locked plugin, see the [plugin reference](plugins/README.md).

## 1. Core tools

Install the Xcode command-line tools first. They provide `git`, `make`, and a C compiler.

```shell
xcode-select --install
```

Install the command-line dependencies used directly by the configuration:

```shell
brew install neovim ripgrep fd tree-sitter-cli lazygit stylua lua-language-server
brew install --cask font-fira-code-nerd-font
```

| Tool | Used by |
| --- | --- |
| `git` | Lazy.nvim bootstrap, Gitsigns, Diffview, worktrees |
| `ripgrep` (`rg`) | Telescope live grep, Grug Far, Obsidian search |
| `fd` | Telescope file discovery |
| `tree-sitter-cli`, `curl`, `tar`, C compiler | Tree-sitter parser installation |
| `lazygit` | `lazygit.nvim` |
| `stylua` | Conform Lua formatting |
| `lua-language-server` | Lua LSP |
| Nerd Font | File and UI icons |

Tree-sitter requires `tree-sitter-cli` 0.26.1 or newer. Grug Far requires ripgrep 14 or newer.

## 2. Dexter

The Elixir LSP configuration starts `dexter lsp` when `dexter` is available. Language runtime installation is managed separately and is intentionally not covered here.

This setup installs Dexter through asdf:

```shell
brew install asdf
asdf plugin add dexter https://github.com/remoteoss/dexter.git
asdf install dexter 0.7.1
asdf set --home dexter 0.7.1
```

Verify it:

```shell
dexter version
```

## 3. Local AI

OpenCode and Ollama power the local models used by `opencode.nvim`:

```shell
brew install anomalyco/tap/opencode
brew install --cask ollama-app
```

Continue with [OpenCode and Ollama](opencode-ollama.md) to install the models and create the OpenCode configuration.

## 4. Optional plugin dependencies

Install only the groups you use.

| Feature | Dependency | Plugin |
| --- | --- | --- |
| Codex | [Codex CLI](https://learn.chatgpt.com/docs/codex/cli) | `codex.nvim` |
| Claude | [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code/getting-started) | `claudecode.nvim` |
| Docker UI | Docker Desktop and `brew install lazydocker` | `lazydocker.nvim` |
| PostgreSQL | `brew install libpq`; add its `bin` directory to `PATH` | Dadbod and the psql terminal |
| MySQL | MySQL command-line client | Dadbod MySQL connections |
| SQLite | `sqlite3` | Dadbod SQLite connections |
| Gleam | `brew install gleam` | Gleam LSP |
| Obsidian | Obsidian app and `OBSIDIAN_VAULT` | `obsidian.nvim` |
| Tests | The test runner for the current project | `vim-test` |

Codex and Claude are optional. Their Neovim plugins load on demand and only work when the matching CLI is in `PATH`.

For Obsidian, set the vault without committing a machine-specific path:

```shell
export OBSIDIAN_VAULT="/path/to/vault"
```

Database credentials must come from the environment. Do not put them in this repository.

## 5. Install and verify plugins

Start Neovim and run:

```vim
:Lazy sync
:checkhealth
```

Feature-specific checks:

```vim
:ConformInfo
:checkhealth lazydocker
:Obsidian check
```

Pure Lua plugins not listed here require no separate system installation.
