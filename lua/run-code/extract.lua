local extract = {}

-- returns a table containing every line in the file
extract.lines_from_current_buffer = function()
  local curr_buff = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(curr_buff)

  return vim.api.nvim_buf_get_lines(curr_buff, 0, line_count, false)
end

return extract
