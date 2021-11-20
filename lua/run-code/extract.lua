local extract = {}

-- returns a table containing every line in the file
extract.lines_from_current_buffer = function()
  local curr_buff = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(curr_buff)

  return vim.api.nvim_buf_get_lines(curr_buff, 0, line_count, false)
end

-- returns a table containing the lines that are visually
-- selected
extract.lines_in_range = function(range)
  local start_line = range[1] - 1
  local end_line = range[2]

  local curr_buff = vim.api.nvim_get_current_buf()
  return vim.api.nvim_buf_get_lines(curr_buff, start_line, end_line, false)
end

return extract
