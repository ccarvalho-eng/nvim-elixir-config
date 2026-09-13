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
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    },
  },
  float = {
    border = "rounded",
    source = true,
  },
})
