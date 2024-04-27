local util = require('flow.util')
local vars = require('flow.vars')

local QUICK_HISTORY_FILE = vim.fn.stdpath("data") .. "/flow_nvim_quick_cmd_history"
local MAX_HISTORY_SIZE = 100

local function open_custom_cmd_window(file_name, file_type)
  local win_cols = vim.api.nvim_get_option('columns')
  local win_rows = vim.api.nvim_get_option('lines')
  local screen_coverage = 0.4
  local width = math.floor(win_cols * screen_coverage)
  local height = math.floor(win_rows * screen_coverage)
  local col = math.floor((win_cols - width) / 2)
  local row = math.floor((win_rows - height) / 2)

  local output_win_config = {
    relative = 'editor', border = 'double', style = 'minimal',
    title = 'flow: custom cmd', title_pos = 'center',
    width = width, height = height, col = col, row = row,
  }

  local win = vim.api.nvim_open_win(0, true, output_win_config)
  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buffer)

  if not util.file_exists(file_name) then
    local help_text = vars.vars_help_text()
    local file = io.open(file_name, "w")
    if file == nil then
      print(string.format("flow: couldn't open file '%s' for writing", file_name))
      return
    end

    file:write("\n\n" .. help_text)
    file:close()
  end

  vim.cmd('edit ' .. file_name)
  vim.bo.filetype = file_type

  vim.api.nvim_create_autocmd({'BufDelete', 'BufLeave'}, {
    buffer = buffer,
    callback = function()
      if vim.api.nvim_buf_is_valid(buffer) then
        vim.api.nvim_buf_delete(buffer, {force = false})
      end
    end
  })

  vim.api.nvim_buf_set_keymap(buffer, "n", "<esc>", ":q<cr>", {
    callback = function()
      if vim.api.nvim_buf_get_option(buffer, "modified") then
        return
      end

      vim.api.nvim_buf_delete(buffer, {force = false})
    end,
  })
end

local function open_quick_cmd_window(callback)
  local win_cols = vim.api.nvim_get_option('columns')
  local win_rows = vim.api.nvim_get_option('lines')
  local help_text = util.str_split("\n\n"..vars.vars_help_text(true), "\n")

  local screen_coverage = 0.4
  local width = math.floor(win_cols * screen_coverage)
  local height = #help_text
  local col = math.floor((win_cols - width) / 2)
  local row = math.floor((win_rows - height) / 2)
  local history = util.file_to_table(QUICK_HISTORY_FILE)

  local output_win_config = {
    relative = 'editor', border = 'double', style = 'minimal',
    title = 'flow: custom cmd', title_pos = 'center',
    width = width, height = height, col = col, row = row,
  }

  local win = vim.api.nvim_open_win(0, true, output_win_config)
  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buffer)
  vim.bo.filetype = "bash"

  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, help_text)

  -- start in insert mode
  vim.api.nvim_command("startinsert")


  local handle_enter = function()
    local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
    local text = table.concat(lines, "\n")
    if callback ~= nil then
      callback(text)
    end

    -- store the command in history
    table.insert(history, text)
    history = util.dedup(history)

    if #history > MAX_HISTORY_SIZE then
      -- take the last MAX_HISTORY_SIZE elements
      history = util.tail_n(history, MAX_HISTORY_SIZE)
    end

    util.table_to_file(history, QUICK_HISTORY_FILE)
    vim.api.nvim_buf_delete(buffer, {force = false})
  end


  vim.api.nvim_buf_set_keymap(buffer, "n", "<esc>", ":q<cr>", {})

  -- on pressing enter, call the callback with the text present in the buffer
  vim.api.nvim_buf_set_keymap(buffer, "n", "<cr>", "", {
    callback = handle_enter,
  })

  vim.api.nvim_buf_set_keymap(buffer, "i", "<cr>", "<esc>", {
    callback = function ()
      -- switch to normal mode
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', false
      )

      handle_enter()
    end
  })

  -- navigate history
  local history_index = #history + 1
  vim.api.nvim_buf_set_keymap(buffer, "i", "<c-p>", "", {
    callback = function ()
      if history_index == 1 then
        return
      end

      history_index = history_index - 1
      vim.api.nvim_buf_set_lines(buffer, 0, -1, false, util.str_split(history[history_index], "\n"))
    end
  })

  vim.api.nvim_buf_set_keymap(buffer, "i", "<c-n>", "", {
    callback = function ()
      if history_index == #history then
        return
      end

      history_index = history_index + 1
      vim.api.nvim_buf_set_lines(buffer, 0, -1, false, util.str_split(history[history_index], "\n"))
    end
  })
end

return {
  open_custom_cmd_window = open_custom_cmd_window,
  open_quick_cmd_window = open_quick_cmd_window,
}
