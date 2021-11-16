local cmd = require("run-code.cmd").cmd

function execute_block(block)
  local c = cmd(block)
  if c == "" then
    print(string.format("this language doesn't seem to be supported yet"))
    return
  end

  run_and_print(c)
end

-- this is not safe!!
-- craps out when the code is an interactive process
-- will live with it for now
function run_and_print(cmd)
-- TODO:
--    - handle errors
--    - timeout commands if they are taking too long
  local result = ""
  local handle = io.popen(cmd)
  result = handle:read("*a")
  handle:flush()
  handle:close()

  print(result)
end

return {
  execute_block = execute_block
}
