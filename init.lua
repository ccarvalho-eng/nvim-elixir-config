-- Neovim Configuration for Elixir Development

-- Leader key (must be set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Display settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8

-- Mouse and clipboard
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search behavior
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Backup and swap
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Load plugins
require("plugins")

-- Cycle through One Dark styles: dark -> darker -> light -> dark
local function toggle_theme()
  local styles = { "dark", "darker", "light" }
  local current = vim.g.onedark_style or "dark"

  -- Find current index
  local current_index = 1
  for i, style in ipairs(styles) do
    if style == current then
      current_index = i
      break
    end
  end

  -- Cycle to next style
  local next_index = (current_index % #styles) + 1
  vim.g.onedark_style = styles[next_index]
  require('onedark').setup({ style = styles[next_index] })
  require('onedark').load()
end

-- Set initial theme to One Dark dark
vim.g.onedark_style = "dark"
vim.cmd("colorscheme onedark")

-- LSP Keybindings (set when LSP attaches)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'Show references' }))

    -- Actions
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code action' }))
    vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format({ async = false }) end,
      vim.tbl_extend('force', opts, { desc = 'Format buffer' }))
  end,
})

-- Quality of Life Keybindings
-- Clear search highlighting
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlighting' })

-- Cycle through One Dark styles
vim.keymap.set('n', '<leader>ut', toggle_theme, { desc = 'Cycle One Dark styles' })

-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Resize windows with arrows
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Move lines up/down
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Better indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Stay in visual mode when pasting
vim.keymap.set('v', 'p', '"_dP', { desc = 'Paste without yanking' })

-- Buffer navigation
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })

-- Save and quit shortcuts
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>', { desc = 'Quit' })

-- File explorer
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFindFileToggle<cr>', { desc = 'Toggle file tree' })

-- Toggle between module and test file
local function toggle_test_file()
  local file = vim.fn.expand('%:p')
  local alternate_file

  if file:match('_test%.exs?$') then
    -- We're in a test file, go to the module
    alternate_file = file:gsub('/test/', '/lib/'):gsub('_test%.exs?$', '.ex')
  else
    -- We're in a module file, go to the test
    alternate_file = file:gsub('/lib/', '/test/'):gsub('%.ex$', '_test.exs')
  end

  if vim.fn.filereadable(alternate_file) == 1 then
    vim.cmd('edit ' .. alternate_file)
  else
    vim.notify('File not found: ' .. alternate_file, vim.log.levels.WARN)
  end
end

-- Claude Code keybindings
vim.keymap.set('n', '<leader>ac', '<cmd>ClaudeCode<cr>', { desc = 'Toggle Claude Code' })
vim.keymap.set('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Focus Claude Code' })
vim.keymap.set('n', '<leader>ar', '<cmd>ClaudeCode resume<cr>', { desc = 'Resume Claude session' })
vim.keymap.set('n', '<leader>aC', '<cmd>ClaudeCode continue<cr>', { desc = 'Continue Claude session' })
vim.keymap.set('n', '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', { desc = 'Select Claude model' })
vim.keymap.set('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Add current buffer to Claude' })
vim.keymap.set('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>', { desc = 'Send selection to Claude' })
vim.keymap.set('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept Claude diff' })
vim.keymap.set('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Reject Claude diff' })

-- Telescope keybindings
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', { desc = 'Recent files' })
vim.keymap.set('n', '<leader>fp', '<cmd>Telescope project<cr>', { desc = 'Find projects' })

-- Git keybindings
vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })
vim.keymap.set('n', '<leader>gb', '<cmd>Gitsigns blame_line<cr>', { desc = 'Git blame line' })
vim.keymap.set('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>', { desc = 'Preview hunk' })
vim.keymap.set('n', '<leader>gh', '<cmd>Gitsigns reset_hunk<cr>', { desc = 'Reset hunk' })
vim.keymap.set('n', '<leader>gy', '<cmd>lua require("gitlinker").get_buf_range_url("n")<cr>', { desc = 'Copy GitHub link' })
vim.keymap.set('v', '<leader>gy', '<cmd>lua require("gitlinker").get_buf_range_url("v")<cr>', { desc = 'Copy GitHub link (selection)' })

-- vim-test Keybindings
vim.keymap.set('n', '<leader>tn', '<cmd>TestNearest<cr>', { desc = 'Test nearest' })
vim.keymap.set('n', '<leader>tf', '<cmd>TestFile<cr>', { desc = 'Test file' })
vim.keymap.set('n', '<leader>ts', '<cmd>TestSuite<cr>', { desc = 'Test suite' })
vim.keymap.set('n', '<leader>tl', '<cmd>TestLast<cr>', { desc = 'Test last' })
vim.keymap.set('n', '<leader>tv', '<cmd>TestVisit<cr>', { desc = 'Test visit' })
vim.keymap.set('n', '<leader>ta', toggle_test_file, { desc = 'Toggle test/module file (alternate)' })
