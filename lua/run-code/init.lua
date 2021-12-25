local exe = require('run-code.execute')
local extract = require('run-code.extract')
local md = require('run-code.markdown')
local setup_options = {}

local function handle_md_file(lines)
  local blocks = md.code_blocks_in_lines(lines)
  local block = md.select_block(blocks)

  if block == nil then
    print("run-code: you are not on any code block")
    return
  end

  exe.execute(block.lang, block.code, setup_options)
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

  exe.execute(vim.bo.filetype, code, setup_options)
end

local function run_file()
  local lines = extract.lines_from_current_buffer()
  local code = table.concat(lines, "\n")

  exe.execute(vim.bo.filetype, code, setup_options)
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
  reload_plugin = reload_plugin,
  setup = setup
}
