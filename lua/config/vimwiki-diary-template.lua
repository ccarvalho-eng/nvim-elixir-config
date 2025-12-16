local M = {}

local function generate_template()
  local date = os.date("%Y-%m-%d")

  local template = {
    "# " .. date,
    "",
    "## Morning System Boot",
    "",
    "- [ ] Wake / daylight exposure",
    "- [ ] Hydration",
    "- [ ] Mobility or workout",
    "- [ ] Brief mindfulness",
    "- [ ] Shower",
    "- [ ] Light reading or learning",
    "- [ ] Breakfast",
    "- [ ] Workspace reset",
    "",
    "## Daily Outcomes",
    "",
    "- [ ] Define 1–3 concrete deliverables",
    "- [ ] Identify main risk or dependency",
    "",
    "## Async Communication",
    "",
    "- [ ] Email (Proton / Outlook / Gmail)",
    "- [ ] Chat (Slack / Teams) — intentional replies",
    "- [ ] Issue tracking (Linear / GitHub)",
    "",
    "## Deep Work (Protected Time)",
    "",
    "- [ ] Primary engineering task",
    "- [ ] Secondary task or refactor",
    "",
    "## Syncs (If Any)",
    "",
    "- [ ] Stand-up",
    "",
    "## End-of-Day Update",
    "",
    "- Output delivered",
    "- What’s in progress",
    "- Blockers or dependencies",,
    "",
    "## Reflection",
    "",
    "- What worked",
    "- What didn’t",
    "- One improvement for tomorrow",
    "",
    "## Notes",
    "",
    "- ",
  }

  return template
end

local function apply_template()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  -- Check if buffer is empty or only has whitespace
  local is_empty = true
  for _, line in ipairs(lines) do
    if line:match("%S") then
      is_empty = false
      break
    end
  end

  if is_empty then
    local template = generate_template()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, template)

    -- Position cursor at first task checkbox
    vim.api.nvim_win_set_cursor(0, {5, 6})
  end
end

function M.setup()
  local wiki_path = vim.env.VIMWIKI_PATH or vim.fn.expand('~/vimwiki/')
  wiki_path = wiki_path:gsub("/$", "")

  vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = wiki_path .. "/diary/*.md",
    callback = function()
      apply_template()
    end,
    desc = "Apply vimwiki diary template"
  })
end

return M
