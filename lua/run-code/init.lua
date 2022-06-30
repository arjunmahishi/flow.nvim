local extract = require('run-code.extract')
local md = require('run-code.markdown')
local cmd = require("run-code.cmd").cmd
local custom_cmd = require("run-code.cmd").custom_cmd
local output = require("run-code.output")
local default_setup_options = {
  output = {
    buffer = false
  }
}

local setup_options = default_setup_options

local function run(filetype, code)
  local c = cmd(filetype, code)
  if c == "" then
    print(string.format(
      "run-code: the language '%s' doesn't seem to be supported yet", filetype
    ))
    return
  end

  local out = vim.fn.system(c)
  output.handle_output(out, setup_options.output)
end

local function handle_md_file(lines)
  local blocks = md.code_blocks_in_lines(lines)
  local block = md.select_block(blocks)

  if block == nil then
    print("run-code: you are not on any code block")
    return
  end

  run(block.lang, block.code)
end

local function run_block()
  local lines = extract.lines_from_current_buffer()

  if vim.bo.filetype ~= "markdown" then
    print("run-code: sorry! currently RunCodeBlock is only supported in markdown")
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
    print("you need to provide an alias for the custom command (example: :RunCodeCustomCmd 1)")
    return
  end

  local c = custom_cmd(suffix)
  local out = vim.fn.system(c)
  output.handle_output(out, setup_options.output)
end

local function reload_plugin()
  package.loaded['run-code'] = nil
  print "reloaded run-code"
end

local function setup(options)
  setup_options = options
end

return {
  run_block = run_block,
  run_range = run_range,
  run_file = run_file,
  run_custom_cmd = run_custom_cmd,
  reload_plugin = reload_plugin,
  setup = setup
}
