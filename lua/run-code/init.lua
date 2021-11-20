local exe = require('run-code.execute')
local extract = require('run-code.extract')
local md = require('run-code.markdown')

function run()
  -- currently only markdown files are supported
  if vim.bo.filetype ~= "markdown" then
    print("run-code is currently only supported in markdown")
    return
  end

  local lines = extract.lines_from_current_buffer()
  local blocks = md.code_blocks_in_lines(lines)
  local block = md.select_block(blocks)

  if block == nil then
    print("You are not on any code block")
    return
  end

  exe.execute_block(block)
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
  run = run,
  reload_plugin = reload_plugin
}
