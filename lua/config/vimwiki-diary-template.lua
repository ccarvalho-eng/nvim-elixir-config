local M = {}

local function generate_template()
  local date = os.date("%Y-%m-%d")

  local template = {
    "# " .. date,
    "",
    "## Dawn Rituals",
    "",
    "- [ ] Rise with first light",
    "- [ ] Drink cool dawn-water",
    "- [ ] Practice the war-forms",
    "- [ ] Cleanse the night away",
    "- [ ] Still breath and mind",
    "- [ ] Read runes and elder lore",
    "- [ ] Set hearth and tools in order",
    "",
    "## Quest Planning",
    "",
    "- [ ] Mark chief charges (Top 3)",
    "- [ ] Sort the day's tidings",
    "  - [ ] Scribed letters (Proton, Outlook, Gmail)",
    "  - [ ] Raven words (Slack, Teams)",
    "  - [ ] Guild annals (Linear, GitHub)",
    "- [ ] Name deeds before sunfall",
    "",
    "## Council Gatherings",
    "",
    "- [ ]",
    "",
    "## Dusk Report",
    "",
    "- Deeds done under sun",
    "- Labors left unfinished",
    "- Hunts for the morrow",
    "- Trials and ill winds met",
    "",
    "## Evening Reflection",
    "",
    "- Strengths shown",
    "- Falterings revealed",
    "- Wisdom for next dawn",
    "",
    "## Scribe's Notes",
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
