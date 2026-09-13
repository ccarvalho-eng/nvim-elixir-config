# Neovim configuration

Personal Neovim setup for development on macOS.

## New machine

1. Install the external tools in [docs/dependencies.md](docs/dependencies.md).
2. Place this configuration at `~/.config/nvim`.
3. Start Neovim and run `:Lazy sync` followed by `:checkhealth`.

## Guides

- [System dependencies](docs/dependencies.md)
- [OpenCode with local Ollama models](docs/opencode-ollama.md)

Plugin definitions live in `lua/plugins`; shared editor configuration lives in `lua/config`.
