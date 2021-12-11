local function str_split(s, delimiter)
  local result = {}
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match);
  end
  return result
end

local function write_to_buffer(output)
  vim.cmd "vsplit"
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)

  vim.api.nvim_win_set_buf(win, buf)

  vim.opt.modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, str_split(output, "\n"))
  vim.opt.modifiable = false

end

local function plane_print(output)
  print(output)
end

local function handle_output(output)
  write_to_buffer(output)
end

return {
  handle_output = handle_output,
}
