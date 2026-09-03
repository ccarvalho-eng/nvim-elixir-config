-- Style loaded at startup. toggle_theme tracks the live style in
-- vim.g.onedark_style, so both must start from the same value.
local default_style = "dark"

-- Cycle through One Dark variants
local function toggle_theme()
  local styles = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }
  local current = vim.g.onedark_style or default_style

  local current_index = 1
  for i, style in ipairs(styles) do
    if style == current then
      current_index = i
      break
    end
  end

  local next_index = (current_index % #styles) + 1
  vim.g.onedark_style = styles[next_index]
  require('onedark').setup({ style = styles[next_index] })
  require('onedark').load()
  vim.notify("Theme: " .. styles[next_index], vim.log.levels.INFO)
end

return {
  -- One Dark theme
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.onedark_style = default_style

      require('onedark').setup({
        style = default_style,
        code_style = {
          comments = 'italic',
        },
      })

      vim.cmd("colorscheme onedark")
    end,
    keys = {
      { "<leader>ut", toggle_theme, desc = "Cycle One Dark styles" },
    },
  },

  -- Quotes for the greeter splash
  {
    "rubiin/fortune.nvim",
    lazy = true,
    opts = {
      content_type = "quotes",
      display_format = "short",
      max_width = 52,
    },
  },

  -- Greeter shown when nvim starts without a file
  {
    "startup-nvim/startup.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      -- Drawn once, so the quote does not change between measuring the greeter
      -- and rendering it.
      local header = require("config.splash").lines()

      -- Each entry is { label, command, the mapping that does the same thing
      -- outside the greeter }.
      local commands = {
        { " Find file", "Telescope find_files", "<leader>ff" },
        { " Grep text", "Telescope live_grep", "<leader>fg" },
        { " Recent files", "Telescope oldfiles", "<leader>fr" },
        { " Projects", "Telescope project", "<leader>fp" },
        { " Worktrees", "lua require('config.worktree').switch()", "<leader>gww" },
        { " New file", "enew", "<leader>bn" },
      }

      local oldfiles_amount = 5
      local gap = 2

      -- The oldfiles section adds its own heading and a blank line.
      local height = #header + gap + #commands + gap + oldfiles_amount + 2
      local usable = vim.o.lines - vim.o.cmdheight - 1
      local top = math.max(math.floor((usable - height) / 2), 0)

      require("startup").setup({
        header = {
          type = "text",
          align = "center",
          fold_section = false,
          margin = 5,
          content = header,
          highlight = "Statement",
          default_color = "",
          oldfiles_amount = 0,
        },
        body = {
          type = "mapping",
          align = "center",
          fold_section = false,
          margin = 5,
          content = commands,
          highlight = "String",
          default_color = "",
          oldfiles_amount = 0,
        },
        oldfiles = {
          type = "oldfiles",
          oldfiles_directory = false,
          align = "center",
          fold_section = false,
          margin = 5,
          content = {},
          highlight = "Comment",
          default_color = "",
          oldfiles_amount = oldfiles_amount,
        },
        options = {
          mapping_keys = true,
          cursor_column = 0.5,
          empty_lines_between_mappings = false,
          disable_statuslines = true,
          paddings = { top, gap, gap },
        },
        mappings = {
          execute_command = "<CR>",
          open_file = "o",
          open_file_split = "<c-o>",
          open_section = "<TAB>",
          open_help = "?",
        },
        colors = {
          background = "#282c34",
          folded_section = "#56b6c2",
        },
        parts = { "header", "body", "oldfiles" },
      })
    end,
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
    -- The tabline has to exist from startup, so the keys below must not make
    -- lazy.nvim defer the plugin.
    lazy = false,
    keys = {
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
      { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers to the left" },
      { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to the right" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin" },
      { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
      { "<leader>bx", "<cmd>BufferLinePickClose<cr>", desc = "Pick buffer to close" },
      { "<leader>b<", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
      { "<leader>b>", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },
      { "<leader>bse", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by extension" },
      { "<leader>bsd", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by directory" },
      { "<leader>b1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to buffer 1" },
      { "<leader>b2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Go to buffer 2" },
      { "<leader>b3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to buffer 3" },
      { "<leader>b4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Go to buffer 4" },
      { "<leader>b5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Go to buffer 5" },
      { "<leader>b6", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Go to buffer 6" },
      { "<leader>b7", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Go to buffer 7" },
      { "<leader>b8", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Go to buffer 8" },
      { "<leader>b9", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Go to buffer 9" },
      { "<leader>b0", "<cmd>BufferLineGoToBuffer -1<cr>", desc = "Go to last buffer" },
    },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "bdelete %d",
          right_mouse_command = "bdelete %d",
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
}
