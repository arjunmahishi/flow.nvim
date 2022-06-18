local function trim_spaces(str)
  return string.gsub(str, "^%s*(.-)%s*$", "%1")
end

local function func_pwd()
  return trim_spaces(vim.fn.system("pwd"))
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

return {
  vars_to_export = vars_to_export
}
