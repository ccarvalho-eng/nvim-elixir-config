local M = {}

-- Open today's diary in a floating modal window
function M.open_diary_modal()
  local date = os.date("%Y-%m-%d")
  local wiki_path = vim.env.VIMWIKI_PATH or vim.fn.expand('~/vimwiki/')
  wiki_path = wiki_path:gsub("/$", "")
  local diary_path = wiki_path .. '/diary/' .. date .. '.md'

  -- Create or open the diary file in a buffer
  local temp_buf = vim.api.nvim_create_buf(false, false)
  local buf
  vim.api.nvim_buf_call(temp_buf, function()
    vim.cmd('edit ' .. vim.fn.fnameescape(diary_path))
    buf = vim.api.nvim_get_current_buf()
  end)

  -- Delete the temporary buffer if it's different from the loaded one
  if temp_buf ~= buf then
    vim.api.nvim_buf_delete(temp_buf, { force = true })
  end

  -- Calculate window dimensions
  local width = math.floor(vim.o.columns * 0.4)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    border = 'rounded',
  })

  -- Set window options
  vim.api.nvim_win_set_option(win, 'cursorline', true)
  vim.api.nvim_win_set_option(win, 'number', true)
  vim.api.nvim_win_set_option(win, 'relativenumber', true)

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, 'filetype', 'vimwiki')

  -- Close modal with q or <Esc><Esc>
  local opts = { noremap = true, silent = true, buffer = buf }
  vim.keymap.set('n', 'q', '<cmd>q<cr>', opts)
  vim.keymap.set('n', '<Esc><Esc>', '<cmd>q<cr>', opts)

  -- Browse other wiki files with Telescope
  vim.keymap.set('n', '<C-p>', function()
    require('telescope.builtin').find_files({ cwd = wiki_path })
  end, { noremap = true, silent = true, buffer = buf, desc = 'Find wiki files' })
end

return M
