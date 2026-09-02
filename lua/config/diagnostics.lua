-- Neovim ships with virtual_text and virtual_lines both disabled, which leaves
-- signs and underlines as the only indication that a diagnostic exists. Show
-- the full message for the line under the cursor instead, so reading an error
-- never requires a hover or a Trouble window.
vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = false,
  virtual_lines = {
    current_line = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.INFO] = "I",
      [vim.diagnostic.severity.HINT] = "H",
    },
  },
  float = {
    border = "rounded",
    source = true,
  },
})
