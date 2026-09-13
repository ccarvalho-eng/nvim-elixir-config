-- nvim-treesitter calls vim.list.unique while resolving configured languages.
-- Keep this defensive fallback for Neovim builds that do not expose the
-- helper; supported builds retain their native implementation unchanged.
if vim.list == nil then
  vim.list = {}
end

if vim.list.unique == nil then
  function vim.list.unique(items)
    local seen = {}
    local unique_items = {}

    for _, item in ipairs(items) do
      if not seen[item] then
        seen[item] = true
        table.insert(unique_items, item)
      end
    end

    return unique_items
  end
end
