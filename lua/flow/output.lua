-- this file controls how the output is displayed. Currently, there are two
-- ways to display the output:
-- 1. In STDOUT (default)
-- 2. In a separate buffer
--
-- Printing on STDOUT is simple calling the lua print function. Where as
-- printing in a separate buffer can be more configurable

local output_buffer_filetype = 'run-code-output'
local output_win = nil
local output_buf = nil
local last_output = nil

local default_split_cmd = 'vsplit'

local function str_split(s, delimiter)
  local result = {}
  for match in (s..delimiter):gmatch('(.-)'..delimiter) do
    table.insert(result, match);
  end
  return result
end

-- TODO: make the output buffer read only
local function write_to_buffer(output, options)
  local current_working_window = vim.api.nvim_get_current_win()

  -- spawn a new window an buffer if this is the first run
  if output_win == nil or not vim.api.nvim_win_is_valid(output_win) then
    vim.cmd(options.split_cmd or default_split_cmd)
    output_win = vim.api.nvim_get_current_win()
    output_buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_win_set_buf(output_win, output_buf)
  end

  -- switch to the output window and write the output to the buffer
  vim.api.nvim_set_current_win(output_win)
  vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, str_split(output, '\n'))

  -- apply buffer settings
  vim.bo.filetype = output_buffer_filetype

  vim.api.nvim_set_current_win(current_working_window)
end

-- this is meant to be called when the output window/buffer is closed
local function reset_output_win()
  output_win = nil
  output_buf = nil
end

local function plain_print(output)
  print(output)
end

-- handle_output is the main entry function that orchestrates the
-- the method of output
local function handle_output(output, options)
  last_output = output
  if options.buffer then
    write_to_buffer(output, options)
    return
  end

  plain_print(output)
end

local function show_last_output(options)
  if last_output == nil then
    print("flow: you haven't run anything yet")
    return
  end

  handle_output(last_output, options)
end

return {
  handle_output = handle_output,
  reset_output_win = reset_output_win,
  show_last_output = show_last_output,
}
