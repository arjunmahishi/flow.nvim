local cmd = require("run-code.cmd").cmd
local output_file = "/tmp/_run_code.out"

function execute(lang, code)
  local c = cmd(lang, code, output_file)
  if c == "" then
    print(string.format("run-code: the language '%s' doesn't seem to be supported yet", lang))
    return
  end

  print(vim.fn.system(c))
end

return {
  execute = execute
}
