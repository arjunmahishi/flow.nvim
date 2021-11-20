local exe = require('run-code.execute')
local extract = require('run-code.extract')
local md = require('run-code.markdown')

function run_block()
  local lines = extract.lines_from_current_buffer()

  if vim.bo.filetype ~= "markdown" then
    print("Sorry! currently RunCodeBlock is only supported in markdown")
    return
  end

  handle_md_file(lines)
end

function run_range(range)
  local lines = extract.lines_in_range(range)
  local code = table.concat(lines, "\n")

  exe.execute(vim.bo.filetype, code)
end

function handle_md_file(lines)
  local blocks = md.code_blocks_in_lines(lines)
  local block = md.select_block(blocks)

  if block == nil then
    print("You are not on any code block")
    return
  end

  exe.execute(block.lang, block.code)
end

function reload_plugin()
  package.loaded['run-code'] = nil
  print "reloaded run-code"
end

function str_split(s, delimiter)
  local result = {}
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match);
  end
  return result
end

return {
  run_block = run_block,
  run_range = run_range,
  reload_plugin = reload_plugin
}
