-- LSP server registration and buffer-local keymaps.
--
-- This runs from init.lua after lazy.nvim has loaded its eager plugins, not
-- from lua/plugins/. Specs under lua/plugins/ are imported while lazy is still
-- resolving them, so nothing is on the runtimepath yet and a require of a
-- plugin module from there would always miss.

local dexter_hover_notices = {}

local function trim_empty_lines(lines)
  local start_idx = 1
  local end_idx = #lines

  while start_idx <= end_idx and lines[start_idx] == "" do
    start_idx = start_idx + 1
  end

  while end_idx >= start_idx and lines[end_idx] == "" do
    end_idx = end_idx - 1
  end

  return vim.list_slice(lines, start_idx, end_idx)
end

local function format_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if vim.lsp.get_clients({ bufnr = bufnr, name = "dexter" })[1] then
    vim.lsp.buf.format({
      bufnr = bufnr,
      async = false,
      name = "dexter",
      timeout_ms = 3000,
    })
    return
  end

  vim.lsp.buf.format({ bufnr = bufnr, async = false })
end

local function show_dexter_hover(bufnr)
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = "dexter" })[1]
  if not client then
    vim.lsp.buf.hover()
    return
  end

  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  local result = vim.lsp.buf_request_sync(bufnr, "textDocument/hover", params, 1200)
  local hover = result and result[client.id] and result[client.id].result

  if hover and hover.contents then
    local lines = vim.lsp.util.convert_input_to_markdown_lines(hover.contents)
    lines = trim_empty_lines(lines)

    if not vim.tbl_isempty(lines) then
      vim.lsp.util.open_floating_preview(lines, "markdown", {})
      return
    end
  end

  local root = client.config.root_dir or tostring(bufnr)
  local now = vim.uv.now()
  local last_notice = dexter_hover_notices[root] or 0

  if now - last_notice > 10000 then
    dexter_hover_notices[root] = now
    vim.notify("Dexter is still indexing this workspace. Hover docs will populate once that finishes.", vim.log.levels.INFO)
  end
end

-- LSP keybindings (set when LSP attaches)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local opts = { buffer = ev.buf, silent = true }

    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
    vim.keymap.set('n', 'K', function() show_dexter_hover(ev.buf) end,
      vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'Show references' }))

    -- Actions
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code action' }))
    vim.keymap.set('n', '<leader>cf', function() format_buffer(ev.buf) end,
      vim.tbl_extend('force', opts, { desc = 'Format buffer' }))
    vim.keymap.set('n', '<leader>cd', function()
      local line = vim.api.nvim_get_current_line()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local new_line = line .. " |> dbg()"
      vim.api.nvim_set_current_line(new_line)
      vim.api.nvim_win_set_cursor(0, {cursor[1], #new_line - 1})
    end, vim.tbl_extend('force', opts, { desc = 'Append |> dbg()' }))

    if client and client.name == "dexter" and client:supports_method("textDocument/formatting", ev.buf) then
      local group = vim.api.nvim_create_augroup("DexterFormatOnSave", { clear = false })
      vim.api.nvim_clear_autocmds({ group = group, buffer = ev.buf })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        buffer = ev.buf,
        callback = function()
          format_buffer(ev.buf)
        end,
      })
    end
  end,
})

if vim.fn.executable("dexter") == 1 then
  vim.lsp.config("dexter", {
    cmd = { "dexter", "lsp" },
    root_markers = { ".dexter/dexter.db", ".dexter.db", ".git", "mix.exs" },
    filetypes = { "elixir", "eelixir", "heex" },
    init_options = {
      followDelegates = true,
    },
  })

  vim.lsp.enable("dexter")
end

if vim.fn.executable("gleam") == 1 then
  vim.lsp.config("gleam", {
    cmd = { "gleam", "lsp" },
    root_markers = { "gleam.toml", ".git" },
    filetypes = { "gleam" },
  })

  vim.lsp.enable("gleam")
end
