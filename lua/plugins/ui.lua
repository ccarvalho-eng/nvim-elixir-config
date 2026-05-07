return {
  -- Dracula theme
  {
    "Mofiqul/dracula.nvim",
    name = "dracula",
    lazy = false,
    priority = 1000,
    config = function()
      require("dracula").setup({
        italic_comment = true,
      })

      vim.o.background = "dark"
      vim.cmd("colorscheme dracula")
    end,
  },

  -- Lualine status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'dracula-nvim',
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
