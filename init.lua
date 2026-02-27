-- Neovim Configuration for Elixir Development

-- Load options
require("config.options")

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins from lua/plugins/ directory
require("lazy").setup({
  spec = {
    { import = "plugins" }
  }
})

-- Set initial theme to One Dark dark
vim.g.onedark_style = "darker"
vim.cmd("colorscheme onedark")

-- Load keybindings
require("config.keymaps")
