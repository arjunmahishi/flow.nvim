local cmd = require("run-code.cmd").cmd
local output = require("run-code.output")

local function execute(lang, code, options)
  local c = cmd(lang, code)
  if c == "" then
    print(string.format("run-code: the language '%s' doesn't seem to be supported yet", lang))
    return
  end

  local out = vim.fn.system(c)
  output.handle_output(out, options.output)
end

return {
  execute = execute
}
