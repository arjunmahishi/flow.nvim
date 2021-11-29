local cmd = require("run-code.cmd").cmd
local output_file = "/tmp/_run_code.out"

function execute(lang, code)
  local c = cmd(lang, code, output_file)
  if c == "" then
    print(string.format("run-code: the language '%s' doesn't seem to be supported yet", lang))
    return
  end

  run_and_print(c)
end

-- helper functions to execute a command and print its output

function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function read_file(file)
  if not file_exists(file) then return {} end

  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end

  return lines
end

-- run and print the output by reading the file the output was piped to.
-- the error need not explictly be handled since it is already being piped
-- to the same output file
function run_and_print(cmd)
  os.execute(cmd)

  local lines = read_file(output_file)
  for k, v in pairs(lines) do
    print(v)
  end
end

return {
  execute = execute
}
