-- In-editor key reference for octo.nvim.
--
-- Everything is derived from octo's live mapping table, so the cheat sheet and
-- the which-key labels cannot drift from whatever the plugin actually binds.

local M = {}

local LOCALLEADER = "<localleader>"
local KEY_WIDTH = 20

-- Octo's mapping groups, in the order they should be presented.
local GROUPS = {
  { key = "c", label = "Comments" },
  { key = "v", label = "Review" },
  { key = "p", label = "PR actions" },
  { key = "r", label = "Reactions & threads" },
  { key = "l", label = "Labels" },
  { key = "a", label = "Assignees" },
  { key = "i", label = "Issue/PR state" },
  { key = "s", label = "Suggestions" },
  { key = "g", label = "Navigate" },
  { key = "d", label = "Discussion" },
  { key = "n", label = "Notification" },
}

-- Keys of octo's `mappings` table, in the order they should be presented.
local SECTIONS = {
  { key = "pull_request", title = "Pull request buffer" },
  { key = "issue", title = "Issue buffer" },
  { key = "review_diff", title = "Review diff" },
  { key = "file_panel", title = "Review file panel" },
  { key = "review_thread", title = "Review thread" },
  { key = "submit_win", title = "Review submit window" },
  { key = "discussion", title = "Discussion buffer" },
  { key = "notification", title = "Notification list" },
  { key = "runs", title = "Workflow runs" },
  { key = "repo", title = "Repo buffer" },
  { key = "release", title = "Release buffer" },
}

---@param localleader string
---@return table[] which-key group entries
function M.which_key_spec(localleader)
  return vim.tbl_map(function(group)
    return { localleader .. group.key, group = group.label }
  end, GROUPS)
end

local function group_label(key)
  for _, group in ipairs(GROUPS) do
    if group.key == key then
      return group.label
    end
  end
end

local function resolve(lhs, localleader)
  return (lhs:gsub(vim.pesc(LOCALLEADER), function()
    return localleader
  end))
end

-- Rank for the keys shown above a section's subgroups: the options menu first,
-- then bare localleader keys, then motions, then everything else.
local function rank(lhs, localleader)
  if lhs:lower() == "<cr>" then
    return 1
  elseif vim.startswith(lhs, localleader) then
    return 2
  elseif lhs:match("^[%[%]]") then
    return 3
  end
  return 4
end

local function is_visual(mode)
  if type(mode) ~= "table" then
    return false
  end
  return vim.tbl_contains(mode, "x") or vim.tbl_contains(mode, "v")
end

---Splits one section's mappings into the top-level list and the labelled subgroups.
local function classify(section_mappings, localleader)
  local top, groups = {}, {}

  for _, mapping in pairs(section_mappings) do
    local lhs = resolve(mapping.lhs, localleader)
    local row = { lhs = lhs, desc = mapping.desc, visual = is_visual(mapping.mode) }
    local suffix = vim.startswith(lhs, localleader) and lhs:sub(#localleader + 1) or nil
    local label = suffix and #suffix > 1 and group_label(suffix:sub(1, 1)) or nil

    if label then
      groups[label] = groups[label] or {}
      table.insert(groups[label], row)
    else
      table.insert(top, row)
    end
  end

  local function by_key(a, b)
    local ra, rb = rank(a.lhs, localleader), rank(b.lhs, localleader)
    if ra ~= rb then
      return ra < rb
    end
    return a.lhs < b.lhs
  end

  table.sort(top, by_key)
  for _, rows in pairs(groups) do
    table.sort(rows, by_key)
  end

  return top, groups
end

---Renders a cheat sheet from octo's mapping table.
---@param mappings table octo's `config.values.mappings`
---@param localleader string the resolved localleader key
---@param extra table[]|nil extra sections rendered first: { title, rows = { { lhs, desc } } }
---@return { lines: string[], highlights: table[] }
function M.render(mappings, localleader, extra)
  local lines, highlights = {}, {}

  local function add(text)
    table.insert(lines, text)
    return #lines - 1
  end

  local function highlight(line, col_start, col_end, group)
    table.insert(highlights, { line = line, col_start = col_start, col_end = col_end, group = group })
  end

  local function add_title(text)
    highlight(add("  " .. text), 2, 2 + #text, "Title")
  end

  local function add_row(row, indent)
    local key = row.lhs .. string.rep(" ", math.max(1, KEY_WIDTH - #row.lhs))
    local desc = row.desc .. (row.visual and "  [visual too]" or "")
    local line = add(indent .. key .. desc)
    highlight(line, #indent, #indent + #row.lhs, "Special")
  end

  add("  Octo key reference" .. string.rep(" ", 12) .. "localleader = " .. localleader)
  add("  q to close, / to search")

  for _, section in ipairs(extra or {}) do
    if #section.rows > 0 then
      add("")
      add_title(section.title)
      for _, row in ipairs(section.rows) do
        add_row(row, "    ")
      end
    end
  end

  for _, section in ipairs(SECTIONS) do
    local section_mappings = mappings[section.key]
    if section_mappings and not vim.tbl_isempty(section_mappings) then
      local top, groups = classify(section_mappings, localleader)

      add("")
      add_title(section.title)

      for _, row in ipairs(top) do
        add_row(row, "    ")
      end

      for _, group in ipairs(GROUPS) do
        local rows = groups[group.label]
        if rows then
          local line = add("    " .. group.label)
          highlight(line, 4, 4 + #group.label, "Identifier")
          for _, row in ipairs(rows) do
            add_row(row, "      ")
          end
        end
      end
    end
  end

  return { lines = lines, highlights = highlights }
end

local function localleader()
  local key = vim.g.maplocalleader or "\\"
  return key == " " and "<space>" or key
end

---Described `<leader><prefix>*` mappings, as rows for the cheat sheet.
---`keymaps` comes from `nvim_get_keymap`, whose lhs has the leader already
---resolved to a literal key, so the match runs against the raw lhs.
---@param keymaps table[] entries with `lhs` and optional `desc`
---@param leader string
---@param prefix string
---@return table[] rows sorted by key
function M.leader_rows(keymaps, leader, prefix)
  local rows = {}

  for _, map in ipairs(keymaps) do
    if map.desc and vim.startswith(map.lhs, leader .. prefix) then
      table.insert(rows, {
        lhs = "<leader>" .. prefix .. map.lhs:sub(#leader + #prefix + 1),
        desc = map.desc,
      })
    end
  end

  table.sort(rows, function(a, b)
    return a.lhs < b.lhs
  end)

  return rows
end

local function picker_rows(picker_mappings)
  local rows = {}

  for _, mapping in pairs(picker_mappings or {}) do
    table.insert(rows, { lhs = mapping.lhs, desc = mapping.desc })
  end

  table.sort(rows, function(a, b)
    return a.lhs < b.lhs
  end)

  return rows
end

---Opens the cheat sheet in a floating scratch window.
function M.open()
  local ok, octo_config = pcall(require, "octo.config")
  if not ok then
    vim.notify("octo.nvim is not loaded yet - run :Octo first", vim.log.levels.WARN)
    return
  end

  local values = octo_config.values
  local rendered = M.render(values.mappings, localleader(), {
    {
      title = "Anywhere in Neovim",
      rows = M.leader_rows(vim.api.nvim_get_keymap("n"), vim.g.mapleader or "\\", "h"),
    },
    { title = "Inside a picker", rows = picker_rows(values.picker_config.mappings) },
  })

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, rendered.lines)

  local ns = vim.api.nvim_create_namespace("octo_help")
  for _, hl in ipairs(rendered.highlights) do
    vim.api.nvim_buf_set_extmark(bufnr, ns, hl.line, hl.col_start, {
      end_col = hl.col_end,
      hl_group = hl.group,
    })
  end

  vim.bo[bufnr].modifiable = false
  vim.bo[bufnr].filetype = "octohelp"

  local width = math.min(vim.o.columns - 8, 84)
  local height = math.min(vim.o.lines - 6, #rendered.lines)
  local winid = vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = " Octo keys ",
    title_pos = "center",
  })

  vim.wo[winid].cursorline = true
  vim.wo[winid].wrap = false

  for _, key in ipairs({ "q", "<Esc>", "<C-c>" }) do
    vim.keymap.set("n", key, function()
      vim.api.nvim_win_close(winid, true)
    end, { buffer = bufnr, nowait = true, desc = "Close Octo key reference" })
  end
end

---Labels octo's localleader prefixes in which-key, per octo buffer.
local function register_which_key(bufnr)
  if vim.b[bufnr].octo_which_key then
    return
  end

  local ok, wk = pcall(require, "which-key")
  if not ok then
    return
  end

  local leader = vim.g.maplocalleader or "\\"
  local has_octo_mappings = false
  for _, map in ipairs(vim.api.nvim_buf_get_keymap(bufnr, "n")) do
    if vim.startswith(vim.fn.keytrans(map.lhs), leader) then
      has_octo_mappings = true
      break
    end
  end

  if not has_octo_mappings then
    return
  end

  local spec = M.which_key_spec(leader)
  for _, entry in ipairs(spec) do
    entry.buffer = bufnr
  end

  wk.add(spec)
  vim.b[bufnr].octo_which_key = true
end

function M.setup()
  vim.api.nvim_create_user_command("OctoKeys", M.open, { desc = "Octo key reference" })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("OctoHelp", { clear = true }),
    callback = function(args)
      -- Octo applies its mappings while the buffer is being rendered, so defer.
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          register_which_key(args.buf)
        end
      end)
    end,
  })
end

return M
