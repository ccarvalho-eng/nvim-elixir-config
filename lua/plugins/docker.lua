return {
  -- LazyDocker in a floating window, mirroring the LazyGit integration
  {
    "mgierada/lazydocker.nvim",
    dependencies = { "akinsho/toggleterm.nvim" },
    cmd = "Lazydocker",
    opts = {
      border = "rounded",
      width = 0.9,
      height = 0.9,
    },
    config = function(_, opts)
      require("lazydocker").setup(opts)
    end,
    keys = {
      {
        "<leader>ud",
        function()
          require("lazydocker").open()
        end,
        desc = "LazyDocker",
      },
    },
  },
}
