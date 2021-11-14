function run()
  -- TODO:
  -- [DONE] get code to execute
  -- execute code
  -- [DONE] open un-modifiable buffer with vsplit
  -- [DONE] write the output of the code to the buffer
  -- cleanup buffer once done with it

  local code = get_code_from_current_buffer()
  local buf = open_output_buffer()
  write_to_buffer(buf, code)
end

function get_code_from_current_buffer()
  local curr_buff = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(curr_buff)
  local lines = vim.api.nvim_buf_get_lines(curr_buff, 0, line_count, false)

  return table.concat(lines, "\n")
end

function open_output_buffer()
  vim.cmd "vsplit"
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true) 

  vim.api.nvim_win_set_buf(win, buf)
  vim.opt.modifiable = false

  return buf
end

function write_to_buffer(buf, text)
  vim.opt.modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, str_split(text, "\n"))
  vim.opt.modifiable = false
end

function reload_plugin()
  package.loaded['run-scheme'] = nil
  print "reloaded run-scheme"
end

function str_split(s, delimiter)
  local result = {}
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match);
  end
  return result
end

run()

return {
  run = run,
  reload_plugin = reload_plugin
}
