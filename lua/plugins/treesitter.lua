local filetypes = {
  "elixir",
  "heex",
  "eex",
  "gleam",
  "lua",
  "vim",
  "vimdoc",
  "markdown",
  "markdown_inline",
  "yaml",
  "xml",
  "html",
}
local indent_filetypes = {
  elixir = true,
  heex = true,
  eex = true,
  gleam = true,
  lua = true,
  markdown = true,
}

return {
  -- Tree-sitter for syntax highlighting and indentation
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    cmd = { "TSInstall", "TSUpdate", "TSUninstall", "TSLog" },
    config = function()
      local status_ok, treesitter = pcall(require, "nvim-treesitter")
      if not status_ok then
        return
      end

      treesitter.setup()
      pcall(treesitter.install, filetypes)

      local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = filetypes,
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)

          if indent_filetypes[vim.bo[args.buf].filetype] then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
