local util = require("flow.util")

local function func_pwd()
  return util.trim_space(vim.fn.system("pwd"))
end

local function func_curr_file()
  return vim.api.nvim_buf_get_name(0)
end

local cmd_variables = {
  pwd = func_pwd,
  curr_file = func_curr_file
}

local function vars_to_export()
  local vars = ""
  for key, func in pairs(cmd_variables) do
    local val = func()
    vars = vars .. " " .. string.format("%s='%s'", key, val)
  end

  return vars
end

local function add_vars(vars)
  for name, val in pairs(vars) do
    local val_type = type(val)

    if val_type == "function" then
      cmd_variables[name] = val
    else
      local func = function()
        return val
      end

      cmd_variables[name] = func
    end
  end
end

local function vars_help_text(vars_only)
  local help_text = "# Variables available for use:\n"
  for key, _ in pairs(cmd_variables) do
    help_text = help_text .. string.format("#  - $%s\n", key)
  end

  if vars_only then
    return util.trim_space(help_text)
  end

  help_text = help_text .. "#\n# save the changes and press <esc> to close the window"
  return help_text
end

return {
  vars_to_export = vars_to_export,
  add_vars = add_vars,
  vars_help_text = vars_help_text,
}
