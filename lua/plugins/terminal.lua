-- Terminal utilities

return {
  -- No plugin required, using built-in terminal
  -- This file provides terminal-related keybindings
  {
    "folke/snacks.nvim", -- Already loaded, just adding keybinding
    keys = {
      {
        "<leader>st",
        function()
          local height = math.floor(vim.o.lines * 0.25)
          vim.cmd('botright ' .. height .. 'split | terminal')
          vim.cmd('startinsert')
        end,
        desc = "Open terminal at bottom (25%)"
      },
    },
  },
}
