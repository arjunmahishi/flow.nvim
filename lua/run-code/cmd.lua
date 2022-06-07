local DATA_DIR = vim.fn.stdpath("data")
local CUSTOM_CMD_FILE = DATA_DIR .. "/" .. "run_code_custom_cmd"

local custom_command_filetype = 'bash'
local custom_command_default_split = '10split'
local custom_command_win = nil
local custom_command_buf = nil

-- TODO: validate if these commands are available
local lang_cmd_map = {
  lua = "lua <<-EOF\n%s\nEOF",
  python = "python <<-EOF\n%s\nEOF",
  ruby = "ruby <<-EOF\n%s\nEOF",
  bash = "bash <<-EOF\n%s\nEOF",
  sh = "sh <<-EOF\n%s\nEOF",
  scheme = "scheme <<-EOF\n%s\nEOF", --TODO: try to clean up the output
  javascript = "node <<-EOF\n%s\nEOF",
  go = "go run ."
}

local function get_custom_cmd()
  local custom_cmd_file = io.open(CUSTOM_CMD_FILE, "r")
  local custom_cmd = ""

  if custom_cmd_file ~= nil then
    custom_cmd = custom_cmd_file:read("a")
    io.close(custom_cmd_file)
  end

  return custom_cmd
end

-- set_custom_cmd opens a small buffer that allows the user to edit the custom
-- command
local function set_custom_cmd()
  vim.cmd(custom_command_default_split .. ' ' .. CUSTOM_CMD_FILE)
  custom_command_win = vim.api.nvim_get_current_win()
  custom_command_buf = vim.api.nvim_get_current_buf()
  vim.bo.filetype = custom_command_filetype
end

-- callback function that gets triggered when the command is saved
local function close_custom_cmd_win()
  if custom_command_win ~= nil then
    vim.api.nvim_win_close(custom_command_win, false)
    custom_command_win = nil
  end

  if custom_command_buf ~= nil then
    vim.api.nvim_buf_delete(custom_command_buf, {})
    custom_command_buf = nil
  end
end

-- constructs a command in the following format:
--
-- <binary to run> <output_file> <<-EOF
--    <code>
-- EOF
--
local function get_default_cmd(lang, code)
  local cmd_tmpl = lang_cmd_map[lang]
  if cmd_tmpl == nil then
    return ""
  end

  return string.format(cmd_tmpl, code)
end

local function cmd(lang, code, options)
  -- if custom commands are enabled and set, run that. Else, fallback to the
  -- default commands
  if options.enable_custom_commands then
    return get_custom_cmd()
  end

  return get_default_cmd(lang, code)
end

return {
  cmd = cmd,
  set_custom_cmd = set_custom_cmd,
  close_custom_cmd_win = close_custom_cmd_win
}
