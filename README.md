# Neovim configuration

Personal Neovim setup for development on macOS.

## New machine

1. Install the external tools in [docs/README.md](docs/README.md).
2. Place this configuration at `~/.config/nvim`.
3. Start Neovim and run `:Lazy sync` followed by `:checkhealth`.

## Guides

- [System and plugin dependencies](docs/README.md)
- [Plugin-by-plugin reference](docs/plugins/README.md)
- [OpenCode with local Ollama models](docs/opencode-ollama.md)

Plugin definitions live in `lua/plugins`; shared editor configuration lives in `lua/config`.
