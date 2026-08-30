-- Terminal utilities

return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>us",
        function()
          Snacks.terminal(nil, {
            win = {
              position = "bottom",
              height = 0.25,
            },
          })
        end,
        desc = "Toggle terminal",
      },
    },
  },
}
