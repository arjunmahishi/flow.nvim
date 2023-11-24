local extract = require('flow.extract')
local md = require('flow.markdown')
local cmd = require("flow.cmd")
local output = require("flow.output")
local sql = require("flow.sql")

local default_setup_options = {
  output = {
    buffer = false
  }
}

local setup_options = default_setup_options

local function run(filetype, code)
  local c = cmd.cmd(filetype, code)
  if c == nil then
    return
  end

  output.handle_output(c, setup_options.output)
end

local function handle_md_file(lines)
  local blocks = md.code_blocks_in_lines(lines)
  local block = md.select_block(blocks)

  if block == nil then
    print("flow: you are not on any code block")
    return
  end

  run(block.lang, block.code)
end

local function run_block()
  local lines = extract.lines_from_current_buffer()

  if vim.bo.filetype ~= "markdown" then
    print("flow: sorry! currently RunCodeBlock is only supported in markdown")
    return
  end

  handle_md_file(lines)
end

local function run_range(range)
  local lines = extract.lines_in_range(range)
  local code = table.concat(lines, "\n")

  run(vim.bo.filetype, code)
end

local function run_file()
  local lines = extract.lines_from_current_buffer()
  local code = table.concat(lines, "\n")

  run(vim.bo.filetype, code)
end

local function run_custom_cmd(suffix)
  if suffix == nil then
    print("flow: you need to provide an alias for the custom command (example: :RunCodeCustomCmd 1)")
    return
  end

  local c = cmd.custom_cmd(suffix)
  output.handle_output(c, setup_options.output)
end

local function run_last_custom_cmd()
  local c = cmd.get_last_custom_cmd()

  if c == nil then
    print("flow: you haven't run a custom command yet")
    return
  end

  output.handle_output(c, setup_options.output)
end

local function show_last_output()
  output.show_last_output(setup_options.output)
end

local function reload_plugin()
  package.loaded['flow'] = nil
  print "reloaded flow"
end

local function setup(options)
  setup_options = options

  cmd.override_cmd_map(options.filetype_cmd_map)
  sql.configs = options.sql_configs
end

return {
  run_block = run_block,
  run_range = run_range,
  run_file = run_file,
  run_custom_cmd = run_custom_cmd,
  run_last_custom_cmd = run_last_custom_cmd,
  show_last_output = show_last_output,
  reload_plugin = reload_plugin,
  setup = setup
}
