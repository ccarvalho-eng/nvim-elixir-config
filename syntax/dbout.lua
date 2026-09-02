-- psql result buffers ship with no syntax, so a result set renders as one
-- undifferentiated block of text. Colour the structural parts: the rule under
-- the header, column separators, record markers, the row-count footer, and
-- anything psql reports as an error.
--
-- This has to be a syntax file rather than an ftplugin: setting 'filetype'
-- sets 'syntax' afterwards, which clears any items an ftplugin had defined.
if vim.b.current_syntax then
  return
end

vim.cmd([[
  syntax match dboutSeparator /^[-+]\+$/
  syntax match dboutRecord /^-\[ RECORD \d\+ \]-*$/
  syntax match dboutFooter /^(\d\+ rows\?)$/
  syntax match dboutNotice /^Expanded display is \(on\|off\)\.$/
  syntax match dboutError /^\(ERROR\|FATAL\|PANIC\):.*$/
  syntax match dboutErrorDetail /^\(DETAIL\|HINT\|CONTEXT\|STATEMENT\|LINE \d\+\):.*$/
  " Cell values use lookbehind rather than \zs: \zs only moves where the
  " highlight starts, the match still consumes the pipe, and Vim rejects
  " syntax matches that overlap one already claimed by dboutDelimiter.
  syntax match dboutDelimiter /|/
  syntax match dboutNumber /\(|\s*\|^\s*\)\@<=-\?\d\+\(\.\d\+\)\?\(\s*\(|\|$\)\)\@=/
  syntax match dboutBoolean /\(|\s*\)\@<=[tf]\(\s*\(|\|$\)\)\@=/

  highlight default link dboutSeparator Comment
  highlight default link dboutRecord Title
  highlight default link dboutFooter Comment
  highlight default link dboutNotice Comment
  highlight default link dboutError ErrorMsg
  highlight default link dboutErrorDetail WarningMsg
  highlight default link dboutDelimiter Delimiter
  highlight default link dboutNumber Number
  highlight default link dboutBoolean Boolean
  highlight default link dboutHeader Identifier
]])

-- A column header is the line directly above the ---+--- rule. Syntax rules
-- cannot look ahead a line, and one buffer can hold several result sets, so
-- mark those lines with extmarks instead.
local buf = vim.api.nvim_get_current_buf()
local ns = vim.api.nvim_create_namespace("dbout_header")

vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

for lnum = 2, #lines do
  if lines[lnum]:match("^[-+]+$") and lines[lnum - 1]:match("%S") then
    vim.api.nvim_buf_set_extmark(buf, ns, lnum - 2, 0, {
      end_row = lnum - 1,
      hl_group = "dboutHeader",
      hl_eol = true,
    })
  end
end

vim.b.current_syntax = "dbout"
