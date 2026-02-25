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
vim.g.onedark_style = "darker"
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
    vim.keymap.set('n', '<leader>cD', function()
      local line = vim.api.nvim_get_current_line()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local new_line = line .. " |> dbg()"
      vim.api.nvim_set_current_line(new_line)
      vim.api.nvim_win_set_cursor(0, {cursor[1], #new_line - 1})
    end, vim.tbl_extend('force', opts, { desc = 'Append |> dbg()' }))
  end,
})

-- Quality of Life Keybindings
-- Clear search highlighting
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlighting' })

-- Cycle through One Dark styles
vim.keymap.set('n', '<leader>ut', toggle_theme, { desc = 'Cycle One Dark styles' })

-- Dashboard
vim.keymap.set('n', '<leader>ud', '<cmd>lua Snacks.dashboard()<cr>', { desc = 'Open dashboard' })

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

-- Shell
vim.keymap.set('n', '<leader>sh', function()
  local height = math.floor(vim.o.lines * 0.25)
  vim.cmd('botright ' .. height .. 'split | terminal')
  vim.cmd('startinsert')
end, { desc = 'Open terminal at bottom (25%)' })

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
    -- Create test file if it doesn't exist
    if alternate_file:match('_test%.exs$') then
      local dir = vim.fn.fnamemodify(alternate_file, ':h')
      vim.fn.mkdir(dir, 'p')

      -- Extract module name from source file
      local module_name = nil
      if vim.fn.filereadable(file) == 1 then
        local lines = vim.fn.readfile(file)
        for _, line in ipairs(lines) do
          local match = line:match('^%s*defmodule%s+([%w%.]+)')
          if match then
            module_name = match
            break
          end
        end
      end

      -- Fallback to filename if module not found
      if not module_name then
        module_name = vim.fn.fnamemodify(file, ':t:r')
        module_name = module_name:sub(1, 1):upper() .. module_name:sub(2)
      end

      local content = string.format([[defmodule %sTest do
  use ExUnit.Case
  doctest %s

  test "" do
  end
end
]], module_name, module_name)

      vim.fn.writefile(vim.split(content, '\n'), alternate_file)
      vim.cmd('edit ' .. alternate_file)
      vim.notify('Created: ' .. alternate_file, vim.log.levels.INFO)
    else
      vim.notify('File not found: ' .. alternate_file, vim.log.levels.WARN)
    end
  end
end

-- AI Assistants

-- Claude Code
vim.keymap.set('n', '<leader>act', '<cmd>ClaudeCode<cr>', { desc = 'Toggle Claude Code' })
vim.keymap.set('n', '<leader>acf', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Focus Claude Code' })
vim.keymap.set('n', '<leader>acr', '<cmd>ClaudeCode resume<cr>', { desc = 'Resume session' })
vim.keymap.set('n', '<leader>acc', '<cmd>ClaudeCode continue<cr>', { desc = 'Continue session' })
vim.keymap.set('n', '<leader>acm', '<cmd>ClaudeCodeSelectModel<cr>', { desc = 'Select model' })
vim.keymap.set('n', '<leader>acb', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Add buffer' })
vim.keymap.set('v', '<leader>acs', '<cmd>ClaudeCodeSend<cr>', { desc = 'Send selection' })
vim.keymap.set('n', '<leader>aca', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept diff' })
vim.keymap.set('n', '<leader>acd', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Deny diff' })

-- GitHub Copilot
vim.keymap.set({'n', 'v'}, '<leader>app', '<cmd>CopilotChat<cr>', { desc = 'Open Chat Panel' })
vim.keymap.set({'n', 'v'}, '<leader>apc', '<cmd>CopilotChatClose<cr>', { desc = 'Close Chat' })
vim.keymap.set('n', '<leader>apa', '<cmd>Copilot auth<cr>', { desc = 'Authenticate' })
vim.keymap.set('n', '<leader>aps', '<cmd>Copilot status<cr>', { desc = 'Status' })

vim.keymap.set('n', '<leader>ape', '<cmd>Copilot enable<cr>', { desc = 'Enable' })
vim.keymap.set('n', '<leader>apd', '<cmd>Copilot disable<cr>', { desc = 'Disable' })
vim.keymap.set('n', '<leader>apt', '<cmd>lua require("copilot.suggestion").toggle_auto_trigger()<cr>', { desc = 'Toggle auto-suggestions' })
vim.keymap.set('n', '<leader>apl', '<cmd>Copilot signout<cr>', { desc = 'Sign out' })
vim.keymap.set('n', '<leader>apv', '<cmd>Copilot version<cr>', { desc = 'Version' })
vim.keymap.set({'n', 'v'}, '<leader>apqe', '<cmd>CopilotChatExplain<cr>', { desc = 'Explain code' })
vim.keymap.set({'n', 'v'}, '<leader>apqf', '<cmd>CopilotChatFix<cr>', { desc = 'Fix problems' })
vim.keymap.set({'n', 'v'}, '<leader>apqo', '<cmd>CopilotChatOptimize<cr>', { desc = 'Optimize code' })
vim.keymap.set({'n', 'v'}, '<leader>apqd', '<cmd>CopilotChatDocs<cr>', { desc = 'Generate docs' })
vim.keymap.set({'n', 'v'}, '<leader>apqt', '<cmd>CopilotChatTests<cr>', { desc = 'Generate tests' })
vim.keymap.set({'n', 'v'}, '<leader>apqr', '<cmd>CopilotChatReview<cr>', { desc = 'Review code' })
vim.keymap.set({'n', 'v'}, '<leader>apqc', '<cmd>CopilotChatCommit<cr>', { desc = 'Generate commit message' })

vim.keymap.set('n', '<leader>apm', '<cmd>CopilotChatModels<cr>', { desc = 'Select model' })
vim.keymap.set({'n', 'v'}, '<leader>apr', '<cmd>CopilotChatReset<cr>', { desc = 'Reset chat history' })
vim.keymap.set('n', '<leader>apo', '<cmd>lua require("copilot.panel").open({ position = "right", ratio = 0.4 })<cr>', { desc = 'Open suggestions panel' })

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
