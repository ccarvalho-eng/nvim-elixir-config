-- Minimal init for plenary test runs: config lua/ plus plenary on the runtimepath.
local root = vim.fn.fnamemodify(vim.fn.resolve(debug.getinfo(1, "S").source:sub(2)), ":p:h:h")

vim.opt.runtimepath:append(root)
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/plenary.nvim")

vim.g.mapleader = " "
vim.g.maplocalleader = ","
