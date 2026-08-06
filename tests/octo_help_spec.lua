local help = require("config.octo_help")

local MAPPINGS = {
  issue = {
    issue_options = { lhs = "<CR>", desc = "show issue options" },
    add_comment = { lhs = "<localleader>ca", desc = "add comment" },
    add_reply = { lhs = "<localleader>cr", desc = "add reply" },
    add_label = { lhs = "<localleader>la", desc = "add label" },
    open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
    next_comment = { lhs = "]c", desc = "go to next comment" },
  },
  review_diff = {
    add_review_comment = { lhs = "<localleader>ca", desc = "add a new review comment", mode = { "n", "x" } },
    focus_files = { lhs = "<localleader>e", desc = "move focus to changed file panel" },
  },
}

local function index_of(lines, pattern, from)
  for i = from or 1, #lines do
    if lines[i]:find(pattern, 1, true) then
      return i
    end
  end
end

describe("octo_help.render", function()
  it("substitutes <localleader> with the configured key", function()
    local lines = help.render(MAPPINGS, ",").lines

    assert.is_nil(index_of(lines, "<localleader>"))
    assert.is_not_nil(index_of(lines, ",ca"))
  end)

  it("titles only the sections that have mappings", function()
    local lines = help.render(MAPPINGS, ",").lines

    assert.is_not_nil(index_of(lines, "Issue buffer"))
    assert.is_not_nil(index_of(lines, "Review diff"))
    assert.is_nil(index_of(lines, "Discussion buffer"))
  end)

  it("puts localleader mappings under labelled subgroups", function()
    local lines = help.render(MAPPINGS, ",").lines

    local comments = index_of(lines, "Comments")
    local add_comment = index_of(lines, ",ca")
    local labels = index_of(lines, "Labels")

    assert.is_not_nil(comments)
    assert.is_true(comments < add_comment)
    assert.is_not_nil(labels)
  end)

  it("lists <CR> first within a section", function()
    local lines = help.render(MAPPINGS, ",").lines

    local title = index_of(lines, "Issue buffer")
    local cr = index_of(lines, "<CR>")
    local browser = index_of(lines, "<C-b>")

    assert.is_true(title < cr)
    assert.is_true(cr < browser)
  end)

  it("keeps single-key localleader mappings out of the subgroups", function()
    local lines = help.render(MAPPINGS, ",").lines

    local diff = index_of(lines, "Review diff")
    local focus = index_of(lines, ",e")
    local comments = index_of(lines, "Comments", diff)

    assert.is_true(diff < focus)
    assert.is_true(focus < comments)
  end)

  it("marks mappings that also work in visual mode", function()
    local lines = help.render(MAPPINGS, ",").lines
    local row = lines[index_of(lines, "add a new review comment")]

    assert.is_not_nil(row:find("visual", 1, true))
  end)

  it("reports highlights for section titles", function()
    local rendered = help.render(MAPPINGS, ",")
    local title = index_of(rendered.lines, "Issue buffer")

    local found = false
    for _, hl in ipairs(rendered.highlights) do
      if hl.line == title - 1 and hl.group == "Title" then
        found = true
      end
    end

    assert.is_true(found)
  end)
end)

describe("octo_help.leader_rows", function()
  -- nvim_get_keymap returns lhs with the leader already resolved to a literal
  -- space, so the prefix match has to work on the raw lhs.
  local KEYMAPS = {
    { lhs = " hp", desc = "List GitHub pull requests" },
    { lhs = " ha", desc = "GitHub PRs assigned to me" },
    { lhs = " ff", desc = "Find files" },
    { lhs = " hn" },
  }

  it("collects <leader>h mappings under a space leader", function()
    local rows = help.leader_rows(KEYMAPS, " ", "h")

    assert.are.equal(2, #rows)
    assert.are.equal("<leader>ha", rows[1].lhs)
    assert.are.equal("<leader>hp", rows[2].lhs)
    assert.are.equal("GitHub PRs assigned to me", rows[1].desc)
  end)

  it("ignores mappings outside the prefix and those without a description", function()
    local rows = help.leader_rows(KEYMAPS, " ", "h")

    for _, row in ipairs(rows) do
      assert.is_not_nil(row.desc)
      assert.are_not.equal("Find files", row.desc)
    end
  end)
end)

describe("octo_help.which_key_spec", function()
  it("returns a group entry per localleader prefix", function()
    local spec = help.which_key_spec(",")

    local labels = {}
    for _, entry in ipairs(spec) do
      labels[entry[1]] = entry.group
    end

    assert.are.equal("Comments", labels[",c"])
    assert.are.equal("Labels", labels[",l"])
    assert.are.equal("Review", labels[",v"])
  end)

  it("honours a different localleader", function()
    local spec = help.which_key_spec("\\")

    assert.are.equal("\\c", spec[1][1]:sub(1, 2))
  end)
end)
