return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>ud",
        function()
          if vim.fn.executable("lazydocker") ~= 1 then
            vim.notify("lazydocker is not installed", vim.log.levels.WARN)
            return
          end

          Snacks.terminal("lazydocker", {
            win = {
              border = "rounded",
              height = 0.9,
              width = 0.9,
            },
          })
        end,
        desc = "LazyDocker",
      },
    },
  },
}
