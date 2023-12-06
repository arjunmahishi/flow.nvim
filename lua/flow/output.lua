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
local job_id = nil

local default_split_cmd = 'vsplit'
local default_modifiable = false
local default_buffer_size = "auto"

local status_pos = 'right'
local status_running = "(🏃 running...)"
local status_inturrupted = "(🛑 inturrupted)"
local status_success = "(✅)"
local status_failed_exit_code = "(❌ exit code: %d)"

local function stop_job()
  vim.fn.jobstop(job_id)
end

local function get_output_win_config(output_arr, options)
  local size = options.size or default_buffer_size
  local win_cols = vim.api.nvim_get_option('columns')
  local win_rows = vim.api.nvim_get_option('lines')
  local output_win_config = {
    relative = 'editor', border = 'double', style = 'minimal',
    title = status_running, title_pos = status_pos,
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

  -- override the config values if window_override is set
  for key, value in pairs(options.window_override or {}) do
    output_win_config[key] = value
  end

  return output_win_config
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

-- data is the array that the on_stdout/on_stderr callbacks receive
local function clean_output_data(data)
  local clean_data = {}
  for _, line in ipairs(data) do
    if line ~= "" then
      table.insert(clean_data, line)
    end
  end

  return clean_data
end

local function stream_output(cmd, options)
  local win_launched = false
  local buffer = nil
  local win = nil
  local command = { "bash", "-c", cmd }

  local output_callback = function(_, data, _)
    data = clean_output_data(data)
    if #data == 0 then
      return
    end

    if not win_launched then
      -- win = vim.api.nvim_open_win(0, true, get_output_win_config(data, options))
      win = vim.api.nvim_open_win(0, true, {
        width = 80, height = 20, col = 0, row = 0,
        relative = 'editor', style = 'minimal',
      })
      win_launched = true

      buffer = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_win_set_buf(win, buffer)

      vim.api.nvim_buf_set_keymap(buffer, 'n', '<esc>', ':q<cr>', {noremap = true, silent = true})

      -- stop the job when <C-c> is pressed
      vim.api.nvim_buf_set_keymap(buffer, 'n', '<c-c>', ':lua require("flow.output").stop_job()<cr>', {noremap = true, silent = true})

    end

    vim.api.nvim_buf_set_lines(buffer, -1, -1, false, data)
    local buf_contents = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
    last_output = buf_contents

    -- resize the window to fit the contents
    vim.api.nvim_win_set_config(win, get_output_win_config(buf_contents, options))

    -- scroll to the bottom of the buffer
    vim.api.nvim_win_set_cursor(win, {vim.api.nvim_buf_line_count(buffer), 0})
  end

  job_id = vim.fn.jobstart(command, {
    on_stdout = output_callback,
    on_stderr = output_callback,
    on_exit = function(_, data, _)
      if buffer == nil then
        return
      end

      vim.api.nvim_buf_set_option(buffer, 'modifiable', options.modifiable or default_modifiable)
      vim.api.nvim_buf_set_keymap(buffer, 'n', '<enter>', ':q<cr>', {
        noremap = true, silent = true,
      })

      if data == 143 then
        vim.api.nvim_win_set_config(win, {
          title = status_inturrupted, title_pos = status_pos,
        })
        return
      end

      if data == 0 then
        vim.api.nvim_win_set_config(win, {
          title = status_success, title_pos = status_pos,
        })
        return
      end

      vim.api.nvim_win_set_config(win, {
        title = string.format(status_failed_exit_code, data),
        title_pos = status_pos,
      })
    end,
  })
end

-- handle_output is the main entry function that orchestrates the
-- the method of output
local function handle_output(cmd, options)
  options = options or {}

  if options.buffer == false then
    local output = vim.fn.system(cmd)
    last_output = output
    plain_print(output)
    return
  end

  if options.split_cmd ~= nil then
    local output = vim.fn.system(cmd)
    last_output = output
    write_to_buffer_legacy(output, options)
    return
  end

  stream_output(cmd, options)
end

local function show_last_output(options)
  if last_output == nil then
    print("flow: you haven't run anything yet")
    return
  end

  -- this is a quick hack to simply print the last output, by reusing the
  -- handle_output function
  local last_output_str = table.concat(last_output, "\n")
  local cmd = "cat <<EOF\n" .. last_output_str .. "\nEOF\n"
  handle_output(cmd, options)
end

return {
  handle_output = handle_output,
  reset_output_win = reset_output_win,
  show_last_output = show_last_output,
  stop_job = stop_job,
}
