-- this file controls how the output is displayed. Currently, there are two
-- ways to display the output:
-- 1. In STDOUT (default)
-- 2. In a separate buffer
--
-- Printing on STDOUT is simple calling the lua print function. Where as
-- printing in a separate buffer can be more configurable

local str_split = require('flow.util').str_split

local output_buffer_filetype = 'run-code-output'
local output_win = nil
local output_buf = nil
local last_output = nil

local default_split_cmd = 'vsplit'
local default_type = 'float'
local default_focused = true
local default_modifiable = false
local default_buffer_size = "auto"

function get_output_win_config(output_arr, options)
  local size = options.size or default_buffer_size
  local win_cols = vim.api.nvim_get_option('columns')
  local win_rows = vim.api.nvim_get_option('lines')
  local output_win_config = {
    relative = 'editor',
    border = 'double',
    style = 'minimal',
  }

  -- if the size is auto, then calculate the size based on the
  -- output length.
  if size == "auto" then
    local max_len = 0
    for _, line in ipairs(output_arr) do
      if #line > max_len then
        max_len = #line
      end
    end

    output_win_config.width = math.min(max_len + 4, math.floor(win_cols * 0.9))
    output_win_config.height = math.min(#output_arr, math.floor(win_rows * 0.9))
  else
    output_win_config.width = math.floor((win_cols * size) / 100)
    output_win_config.height = math.floor((win_rows * size) / 100)
  end

  -- place the window at the center of the screen
  output_win_config.col = math.floor((win_cols - output_win_config.width) / 2)
  output_win_config.row = math.floor((win_rows - output_win_config.height) / 2)

  -- override the config values if the custom_window is set
  for key, value in pairs(options.window_override or {}) do
    output_win_config[key] = value
  end

  return output_win_config
end

local function write_to_buffer(output, options)
  output = output:gsub("%s+$", "")

  -- if there is no output, then just print a message and return
  if output == "" then
    print("flow: no output to display")
    return
  end

  local output_arr = str_split(output, '\n')
  local current_working_window = vim.api.nvim_get_current_win()
  
  -- Create the floating window
  local win = vim.api.nvim_open_win(0, true, get_output_win_config(output_arr, options))

  -- create buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- set buffer
  vim.api.nvim_win_set_buf(win, buf)

  -- set lines
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, output_arr)

  -- modifiability
  vim.api.nvim_buf_set_option(buf, 'modifiable', options.modifiable or default_modifiable)

  -- set keymap to close window when <esc> is pressed
  vim.api.nvim_buf_set_keymap(buf, 'n', '<esc>', ':q<cr>', {noremap = true, silent = true})

  -- if focused is false, then set focus back to the original window
  if options.focused == false then
    vim.api.nvim_set_current_win(current_working_window)
  end
end

local function write_to_buffer_legacy(output, options)
  local current_working_window = vim.api.nvim_get_current_win()

  -- if this is the first time OR if the window was manually closed
  -- create a fresh output window+buffer set
  if output_win == nil or not vim.api.nvim_win_is_valid(output_win) then
    -- remove the stale buffer, if it exists
    if output_buf ~= nil then
      vim.api.nvim_buf_delete(output_buf, { force = true })
    end

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
    if options.split_cmd ~= nil then
      write_to_buffer_legacy(output, options)
      return
    end

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
