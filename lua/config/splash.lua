local M = {}

-- The dashboard centres each line on its own, so the drawing is padded to a
-- rectangle and kept to ASCII: multi byte characters would throw the alignment.
local cow = {
  [[       \   ^__^]],
  [[        \  (oo)\_______]],
  [[           (__)\       )\/\]],
  [[               ||----w |]],
  [[               ||     ||]],
}

local width = 52

local function quote()
  local ok, fortune = pcall(require, "fortune")

  if not ok then
    return "Neovim"
  end

  local lines = fortune.get_fortune()

  return (table.concat(lines, " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function wrap(message)
  local lines, line = {}, ""

  for word in message:gmatch("%S+") do
    if line == "" then
      line = word
    elseif #line + #word + 1 <= width then
      line = line .. " " .. word
    else
      table.insert(lines, line)
      line = word
    end
  end

  if line ~= "" then
    table.insert(lines, line)
  end

  return lines
end

local function bubble(message)
  local lines = wrap(message)
  local inner = 0

  for _, line in ipairs(lines) do
    inner = math.max(inner, #line)
  end

  local out = { " " .. string.rep("_", inner + 2) }

  for index, line in ipairs(lines) do
    local left, right = "|", "|"

    if #lines == 1 then
      left, right = "<", ">"
    elseif index == 1 then
      left, right = "/", "\\"
    elseif index == #lines then
      left, right = "\\", "/"
    end

    table.insert(out, ("%s %s %s"):format(left, line .. string.rep(" ", inner - #line), right))
  end

  table.insert(out, " " .. string.rep("-", inner + 2))

  return out
end

--- A cow saying whatever fortune.nvim came up with this time.
--- @return string[]
function M.lines()
  local lines = bubble(quote())

  vim.list_extend(lines, cow)

  local widest = 0

  for _, line in ipairs(lines) do
    widest = math.max(widest, #line)
  end

  for index, line in ipairs(lines) do
    lines[index] = line .. string.rep(" ", widest - #line)
  end

  return lines
end

return M
