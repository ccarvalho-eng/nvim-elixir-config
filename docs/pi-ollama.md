# Pi with Ollama

Local coding and writing setup with 32K model contexts to leave memory for the operating system and development tools.

| Model | Real model | Purpose | Size |
| --- | --- | --- | --- |
| `qwen3-coder:deep` | Qwen3 Coder 30B | Larger changes and repository work | 18 GB |
| `qwen2.5-coder:fast` | Qwen2.5 Coder 14B | Quick text-only questions | 9 GB |
| `mistral-small3.2:writing` | Mistral Small 3.2 24B | Prose, essays, and editing | 15 GB |

## 1. Check the tools

```shell
ollama --version
pi --version
nvim --version
```

Start the Ollama app before continuing.

## 2. Pull the models

```shell
ollama pull qwen3-coder:30b
ollama pull qwen2.5-coder:14b
ollama pull mistral-small3.2
```

## 3. Create the 32K profiles

Create `~/.config/ollama/Modelfile.qwen3-coder-deep`:

```dockerfile
FROM qwen3-coder:30b

PARAMETER num_ctx 32768
```

Create `~/.config/ollama/Modelfile.qwen2.5-coder-fast`:

```dockerfile
FROM qwen2.5-coder:14b

PARAMETER num_ctx 32768
```

Create `~/.config/ollama/Modelfile.mistral-small3.2-writing`:

```dockerfile
FROM mistral-small3.2

PARAMETER num_ctx 32768
```

Build the profiles:

```shell
ollama create qwen3-coder:deep -f ~/.config/ollama/Modelfile.qwen3-coder-deep
ollama create qwen2.5-coder:fast -f ~/.config/ollama/Modelfile.qwen2.5-coder-fast
ollama create mistral-small3.2:writing -f ~/.config/ollama/Modelfile.mistral-small3.2-writing
```

## 4. Install the Pi providers and tools

Pi already includes the local coding tools used by this configuration: `read`, `bash`, `edit`, `write`, `grep`, `find`, and `ls`.

Install the pinned native Ollama provider first. It uses Ollama's `/api/chat` endpoint so tool calls reach Pi; Ollama's OpenAI-compatible endpoint can return those calls as plain text instead:

```shell
pi install git:github.com/CaptCanadaMan/pi-ollama@94103da20c02ae26d27378c86f12c8356fb2901b
npm --prefix ~/.pi/agent/git/github.com/CaptCanadaMan/pi-ollama audit --omit=dev
```

Install Ketch and the pinned `pi-web-surf` extension to add keyless DuckDuckGo search and page fetching:

```shell
brew install 1broseidon/tap/ketch
ketch config set backend ddg
pi install git:github.com/yanralapdy/pi-web-surf@edc88b5cbf24ae8199c3c183f6f3e42a9988ab52
npm --prefix ~/.pi/agent/git/github.com/yanralapdy/pi-web-surf audit fix
npm --prefix ~/.pi/agent/git/github.com/yanralapdy/pi-web-surf audit --omit=dev
```

The Neovim integration enables `internet_search` and `internet_scrape` alongside Pi's built-in coding tools. The extension also provides code search, library documentation, and site crawling, but they are excluded from the default tool set to keep prompts smaller and web access focused.

Install the curated Elixir and Phoenix skill package:

```shell
pi install git:github.com/ccarvalho-eng/pi-elixir-phoenix
```

The package provides focused skills for Elixir, Ecto, Phoenix, LiveView, Oban, testing, migrations, security, debugging, verification, runtime durability, safe PostgreSQL inspection through `psql`, version-matched HexDocs lookup, and optional Tidewave inspection. Start a fresh Pi session after installing or updating it. Pi can select skills automatically, or load one explicitly with commands such as `/skill:phx-investigate`, `/skill:postgres-psql`, and `/skill:hexdocs-lookup`.

Pi extensions execute with the same permissions as Pi. Both extension revisions are pinned so upgrades remain deliberate; review newer revisions before changing the pins. The web extension's audit commands update stale transitive dependencies within its installed package without changing its source, then confirm the result.

`qwen3-coder:deep` and `mistral-small3.2:writing` support Pi tool calls through the native provider. The fast Qwen 2.5 Coder profile emits tool-call JSON as text, so use it for text-only questions and switch to the deep model for tasks that need file, shell, or web tools.

## 5. Configure Pi

The native provider discovers the aliases directly from Ollama, so a manual `~/.pi/agent/models.json` entry is unnecessary. Remove an older manual Ollama provider definition when migrating to avoid competing registrations.

The `pi install` commands record both pinned packages in `~/.pi/agent/settings.json`. Preserve those entries and set the deep model as the default; the relevant configuration should be:

```json
{
  "defaultProvider": "ollama",
  "defaultModel": "qwen3-coder:deep",
  "packages": [
    "git:github.com/CaptCanadaMan/pi-ollama@94103da20c02ae26d27378c86f12c8356fb2901b",
    "git:github.com/yanralapdy/pi-web-surf@edc88b5cbf24ae8199c3c183f6f3e42a9988ab52",
    "git:github.com/ccarvalho-eng/pi-elixir-phoenix"
  ]
}
```

## 6. Use it from Neovim

`pi.nvim` reads the global Pi configuration and exposes the same three local models:

- `<leader>ap`: toggle Pi in a right-side panel

Pi runs in RPC mode from Neovim. Project-local Pi settings, extensions, and skills remain disabled until that project is explicitly trusted in the Pi CLI.

Pi does not provide built-in permission prompts. Without a compatible permission extension or an external sandbox, enabled tools can modify files and run commands directly; `pi.nvim` only shows its diff-review flow when such an extension requests it.

## 7. Verify

```shell
ollama list
pi --list-models
ketch --version
ketch search "Pi coding agent" --limit 1 --json
pi list
pi --no-session --provider ollama --model qwen3-coder:deep --tools internet_search --print \
  "Use internet_search with the query Pi coding agent. Reply only with the first result title."
ollama run qwen2.5-coder:fast "Reply with OK"
ollama run mistral-small3.2:writing "Reply with OK"
ollama ps
```

The active profile should report a `32768` context.

## Daily use

```shell
# Default deep model
pi

# One task with the fast model
pi --model ollama/qwen2.5-coder:fast "explain this change"

# One writing task
pi --model ollama/mistral-small3.2:writing "revise this essay"
```

Re-run `ollama create` after changing a Modelfile. Pi reloads its model configuration when the model selector opens.

Keep the context at 32K unless a task requires more. Larger contexts consume more unified memory and may slow the machine.
