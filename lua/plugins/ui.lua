-- Cycle through Catppuccin flavours
local function toggle_theme()
  local flavours = { "latte", "frappe", "macchiato", "mocha" }
  local current = vim.g.catppuccin_flavour or "frappe"

  local current_index = 1
  for i, flavour in ipairs(flavours) do
    if flavour == current then
      current_index = i
      break
    end
  end

  local next_index = (current_index % #flavours) + 1
  local next_flavour = flavours[next_index]

  vim.g.catppuccin_flavour = next_flavour
  require("catppuccin").setup({
    flavour = next_flavour,
    integrations = {
      notify = true,
      treesitter = true,
    },
  })
  vim.cmd.colorscheme("catppuccin")
  vim.notify("Theme: " .. next_flavour, vim.log.levels.INFO)
end

return {
  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.catppuccin_flavour = "frappe"

      require("catppuccin").setup({
        flavour = vim.g.catppuccin_flavour,
        integrations = {
          notify = true,
          treesitter = true,
        },
      })

      vim.cmd("colorscheme catppuccin")
    end,
    keys = {
      { "<leader>ut", toggle_theme, desc = "Cycle Catppuccin flavours" },
    },
  },

  -- Lualine status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
          component_separators = { left = '|', right = '|'},
          section_separators = { left = '', right = ''},
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      })
    end,
  },

  -- Bufferline for tabs
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          indicator = {
            style = 'underline',
          },
          diagnostics = "nvim_lsp",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            }
          },
          show_buffer_close_icons = true,
          show_close_icon = false,
          separator_style = "thin",
        },
      })
    end,
  },

  -- Noice for better UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
    end,
  },

  -- Notify
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
        render = "compact",
        stages = "fade",
      })
      vim.notify = require("notify")
    end,
  },
}
