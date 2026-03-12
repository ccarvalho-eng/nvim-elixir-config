# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Personal Neovim configuration optimized for Elixir development with integrated Claude Code support. Built on lazy.nvim plugin manager with modular plugin architecture.

## Architecture

**Entry Point:** `init.lua` loads three core modules:
- `config.options` - Editor settings (leader key, display, indentation)
- `config.lazy` - Plugin manager bootstrap and loader
- `config.keymaps` - General non-plugin keybindings

**Plugin Loading:** lazy.nvim auto-imports all files from `lua/plugins/` directory. Each plugin file returns a table of plugin specifications.

**Key Plugin Categories:**
- `lsp.lua` - ElixirLS via elixir-tools.nvim, Mason for language server management, LSP keybindings via LspAttach autocmd
- `test.lua` - vim-test integration with custom test/module file toggling (`<leader>ta`)
- `claude.lua` - Claude Code integration with Snacks terminal provider
- `telescope.lua` - Fuzzy finding with project management (base: `~/Projects`)

## ElixirLS Integration

Uses elixir-tools.nvim wrapper pointing to Mason-installed ElixirLS at `~/.local/share/nvim/mason/bin/elixir-ls`. NextLS disabled. Format-on-save enabled for Elixir files. Dialyzer and test lenses enabled.

## Custom Features

**Test File Toggle** (`<leader>ta`): Switches between `lib/` and `test/` files, auto-creating test files with basic ExUnit boilerplate if missing.

**Theme Cycling** (`<leader>ut`): Cycles through One Dark theme variants (dark, darker, cool, deep, warm, warmer, light).

**Elixir Debug Helper** (`<leader>cD`): Appends `|> dbg()` to current line and positions cursor before closing paren.

## Key Bindings Structure

- `<Space>` - Leader key
- `<leader>t*` - Test commands (tn=nearest, tf=file, ts=suite, ta=toggle)
- `<leader>f*` - Telescope find (ff=files, fg=grep, fb=buffers, fp=projects)
- `<leader>a*` - Claude Code actions
- LSP: `gd` (definition), `K` (hover), `gr` (references), `<leader>ca` (code action), `<leader>cf` (format)

## Development Commands

**Check Configuration:**
```bash
nvim --version  # Verify Neovim version
nvim +checkhealth  # Run health checks
```

**Plugin Management:**
- `:Lazy` - Open lazy.nvim UI
- `:Mason` - Manage language servers
- `:checkhealth lazy` - Verify plugin installation

**Testing Elixir Integration:**
Open an Elixir file and verify ElixirLS attaches (`:LspInfo`). Use `<leader>tn` in a test file to run nearest test.

## File Modifications

When modifying plugin configurations:
1. Changes take effect after `:Lazy reload` or restart
2. LSP changes may require `:LspRestart`
3. Keybinding changes in `config/keymaps.lua` need reload

When adding new plugins, create or edit files in `lua/plugins/` - lazy.nvim auto-imports on next startup.
