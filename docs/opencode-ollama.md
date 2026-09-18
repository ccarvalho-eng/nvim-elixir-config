# OpenCode with Ollama

Local coding and writing setup for a 32 GB M1 Pro MacBook, with 32K model
contexts to leave memory for the operating system and development tools.

| Model | Real model | Purpose | Size |
| --- | --- | --- | --- |
| `qwen3-coder:deep` | Qwen3 Coder 30B | Larger changes and repository work | 18 GB |
| `qwen2.5-coder:fast` | Qwen2.5 Coder 14B | Quick edits and questions | 9 GB |
| `mistral-small3.2:writing` | Mistral Small 3.2 24B | Prose, essays, and editing | 15 GB |

## 1. Check the tools

```shell
ollama --version
opencode --version
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

## 4. Configure OpenCode

Set `~/.config/opencode/opencode.jsonc`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "ollama/qwen3-coder:deep",
  "formatter": true,
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "qwen3-coder:deep": {
          "name": "Deep · Qwen3 Coder 30B",
          "limit": {
            "context": 32768,
            "output": 8192
          }
        },
        "qwen2.5-coder:fast": {
          "name": "Fast · Qwen2.5 Coder 14B",
          "limit": {
            "context": 32768,
            "output": 8192
          }
        },
        "mistral-small3.2:writing": {
          "name": "Writing · Mistral Small 3.2 24B",
          "limit": {
            "context": 32768,
            "output": 8192
          }
        }
      }
    }
  }
}
```

The deep model is the default.

## 5. Use it from Neovim

`opencode.nvim` reads the global OpenCode configuration automatically. Every
mapping sits under `<leader>ao`, since `<leader>o` belongs to the Notes group:

- `<leader>aog`: toggle OpenCode
- `<leader>aoi`: open the prompt input
- `<leader>aom`: select the deep, fast, or writing model

Run `:Lazy sync` after adding the plugin, then `<leader>ao` to see the full
group in which-key.

## 6. Verify

```shell
ollama list
opencode models ollama
ollama run qwen2.5-coder:fast "Reply with OK"
ollama ps
```

The active profile should report a `32768` context.

## Daily use

```shell
# Default deep model
opencode

# One task with the fast model
opencode run -m ollama/qwen2.5-coder:fast "explain this change"

# One writing task
opencode run -m ollama/mistral-small3.2:writing "revise this essay"
```

Re-run `ollama create` after changing a Modelfile. Restart OpenCode after
changing its configuration.

Keep the context at 32K unless a task requires more. Larger contexts consume
more unified memory and may slow the machine.
