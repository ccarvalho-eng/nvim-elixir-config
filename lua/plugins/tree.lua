return {
  -- nvim-tree file explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        view = {
          width = 30,
          number = true,
          relativenumber = true,
        },
        renderer = {
          group_empty = true,
          highlight_git = "name",
          indent_markers = {
            enable = true,
          },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
      })
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Toggle file tree" },
    },
  },
}
