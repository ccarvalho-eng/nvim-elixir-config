-- Toggle between module and test file
local function toggle_test_file()
  local file = vim.fn.expand("%:p")
  local alternate_file

  if file:match("_test%.exs?$") then
    alternate_file = file:gsub("/test/", "/lib/"):gsub("_test%.exs?$", ".ex")
  else
    alternate_file = file:gsub("/lib/", "/test/"):gsub("%.ex$", "_test.exs")
  end

  if vim.fn.filereadable(alternate_file) == 1 then
    vim.cmd("edit " .. alternate_file)
  else
    if alternate_file:match("_test%.exs$") then
      local dir = vim.fn.fnamemodify(alternate_file, ":h")
      vim.fn.mkdir(dir, "p")

      local module_name = nil
      if vim.fn.filereadable(file) == 1 then
        local lines = vim.fn.readfile(file)
        for _, line in ipairs(lines) do
          local match = line:match("^%s*defmodule%s+([%w%.]+)")
          if match then
            module_name = match
            break
          end
        end
      end

      if not module_name then
        module_name = vim.fn.fnamemodify(file, ":t:r")
        module_name = module_name:sub(1, 1):upper() .. module_name:sub(2)
      end

      local content = string.format(
        [[defmodule %sTest do
  use ExUnit.Case
  doctest %s

  test "" do
  end
end
]],
        module_name,
        module_name
      )

      vim.fn.writefile(vim.split(content, "\n"), alternate_file)
      vim.cmd("edit " .. alternate_file)
      vim.notify("Created: " .. alternate_file, vim.log.levels.INFO)
    else
      vim.notify("File not found: " .. alternate_file, vim.log.levels.WARN)
    end
  end
end

return {
  -- vim-test for running tests
  {
    "vim-test/vim-test",
    config = function()
      vim.g["test#strategy"] = "neovim"
      vim.g["test#neovim#term_position"] = "vertical"
    end,
    keys = {
      { "<leader>tn", "<cmd>TestNearest<cr>", desc = "Test nearest" },
      { "<leader>tf", "<cmd>TestFile<cr>", desc = "Test file" },
      { "<leader>ts", "<cmd>TestSuite<cr>", desc = "Test suite" },
      { "<leader>tl", "<cmd>TestLast<cr>", desc = "Test last" },
      { "<leader>tv", "<cmd>TestVisit<cr>", desc = "Test visit" },
      { "<leader>ta", toggle_test_file, desc = "Toggle test/module file (alternate)" },
    },
  },
}
