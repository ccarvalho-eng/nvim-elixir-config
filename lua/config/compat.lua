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
