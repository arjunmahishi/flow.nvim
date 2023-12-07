local json = require("flow.lib.json")

local M = {}

M.read_sql_config = function(filename)
    local file = io.open(filename, "r")
    if not file then
        print("Failed to open file: " .. filename)
        return {}
    end

    local json_str = file:read("*all")
    local config = json:decode(json_str)
    file:close()

    return config
end

M.file_exists = function(path)
   local f = io.open(path, "r")
   return f ~= nil and io.close(f)
end

M.str_split = function(s, delimiter)
  local result = {}
  for match in (s..delimiter):gmatch('(.-)'..delimiter) do
    table.insert(result, match);
  end
  return result
end

M.trim_space = function(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

return M
