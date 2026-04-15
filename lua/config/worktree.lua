local M = {}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "Worktree" })
end

local function systemlist(cmd)
  local output = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 then
    return nil
  end

  return output
end

local function git_common_dir()
  local output = systemlist({ "git", "-C", vim.fn.getcwd(), "rev-parse", "--git-common-dir" })

  if not output or not output[1] or output[1] == "" then
    return nil
  end

  return vim.fs.normalize(vim.fn.fnamemodify(output[1], ":p"))
end

local function list_worktrees()
  local output = systemlist({ "git", "-C", vim.fn.getcwd(), "worktree", "list", "--porcelain" })

  if not output then
    return nil
  end

  local worktrees = {}
  local current = nil

  for _, line in ipairs(output) do
    if vim.startswith(line, "worktree ") then
      if current then
        table.insert(worktrees, current)
      end

      current = {
        path = line:sub(10),
        branch = "(detached HEAD)",
      }
    elseif current and vim.startswith(line, "branch ") then
      current.branch = line:sub(8):gsub("^refs/heads/", "")
    elseif current and line == "" then
      table.insert(worktrees, current)
      current = nil
    end
  end

  if current then
    table.insert(worktrees, current)
  end

  return worktrees
end

local function update_tree_root(path)
  pcall(function()
    require("nvim-tree.api").tree.change_root(path)
  end)
end

local function switch_to_worktree(path, opts)
  opts = opts or {}

  if not path or vim.fn.isdirectory(path) == 0 then
    notify("Worktree path is not available: " .. (path or "unknown"), vim.log.levels.ERROR)
    return
  end

  if opts.new_tab then
    vim.cmd.tabnew()
  end

  vim.cmd.tcd(vim.fn.fnameescape(path))
  update_tree_root(path)

  if opts.find_file then
    vim.cmd.edit(".")
  end

  notify("Switched tab to " .. path)
end

local function read_last_worktree()
  local common_dir = git_common_dir()

  if not common_dir then
    return nil
  end

  local marker = vim.fs.joinpath(common_dir, "codex-last-worktree")

  if vim.fn.filereadable(marker) == 0 then
    return nil
  end

  local lines = vim.fn.readfile(marker)
  local path = lines[1]

  if not path or path == "" then
    return nil
  end

  return vim.fs.normalize(path)
end

local function telescope_select(worktrees, opts)
  local ok_pickers, pickers = pcall(require, "telescope.pickers")
  local ok_finders, finders = pcall(require, "telescope.finders")
  local ok_config, telescope_config = pcall(require, "telescope.config")
  local ok_actions, actions = pcall(require, "telescope.actions")
  local ok_state, action_state = pcall(require, "telescope.actions.state")

  if not (ok_pickers and ok_finders and ok_config and ok_actions and ok_state) then
    return false
  end

  local cwd = vim.fs.normalize(vim.fn.getcwd())

  pickers
    .new({}, {
      prompt_title = "Git Worktrees",
      finder = finders.new_table({
        results = worktrees,
        entry_maker = function(item)
          local current = item.path == cwd and "* " or "  "

          return {
            value = item,
            display = string.format("%s%-32s %s", current, item.branch, item.path),
            ordinal = table.concat({ item.branch, item.path }, " "),
          }
        end,
      }),
      sorter = telescope_config.values.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)

          local selection = action_state.get_selected_entry()

          if selection and selection.value then
            switch_to_worktree(selection.value.path, opts)
          end
        end)

        return true
      end,
    })
    :find()

  return true
end

local function select_worktree(opts)
  local worktrees = list_worktrees()

  if not worktrees or vim.tbl_isempty(worktrees) then
    notify("No worktrees found for the current repository", vim.log.levels.WARN)
    return
  end

  if telescope_select(worktrees, opts) then
    return
  end

  local cwd = vim.fs.normalize(vim.fn.getcwd())

  vim.ui.select(worktrees, {
    prompt = "Select worktree",
    format_item = function(item)
      local current = item.path == cwd and "* " or "  "
      return string.format("%s%-32s %s", current, item.branch, item.path)
    end,
  }, function(choice)
    if choice then
      switch_to_worktree(choice.path, opts)
    end
  end)
end

function M.switch()
  select_worktree({ new_tab = false })
end

function M.tab()
  select_worktree({ new_tab = true })
end

function M.last()
  local path = read_last_worktree()

  if path then
    switch_to_worktree(path, { new_tab = false })
    return
  end

  select_worktree({ new_tab = false })
end

function M.last_tab()
  local path = read_last_worktree()

  if path then
    switch_to_worktree(path, { new_tab = true })
    return
  end

  select_worktree({ new_tab = true })
end

function M.setup()
  vim.api.nvim_create_user_command("WorktreeSwitch", function()
    M.switch()
  end, { desc = "Switch this tab to a git worktree for the current repository" })

  vim.api.nvim_create_user_command("WorktreeTab", function()
    M.tab()
  end, { desc = "Open a git worktree in a new tab" })

  vim.api.nvim_create_user_command("WorktreeLast", function()
    M.last()
  end, { desc = "Switch this tab to the last recorded git worktree" })

  vim.api.nvim_create_user_command("WorktreeLastTab", function()
    M.last_tab()
  end, { desc = "Open the last recorded git worktree in a new tab" })
end

return M
