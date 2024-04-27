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

local file_delimiter = ">>>>>>>>>>>>>>>>"

M.table_to_file = function(t, filepath)
  local file = io.open(filepath, "w")
  if not file then
    print("Failed to open file: " .. filepath)
    return
  end

  for _, v in ipairs(t) do
    file:write(v .. "\n" .. file_delimiter .. "\n")
  end

  file:close()
end

M.file_to_table = function(filepath)
  local file = io.open(filepath, "r")
  if not file then
    -- print("Failed to open file: " .. filepath)
    return {}
  end

  local result = {}
  local current = {}
  for line in file:lines() do
    if line == file_delimiter then
      table.insert(result, table.concat(current, "\n"))
      current = {}
    else
      table.insert(current, line)
    end
  end

  file:close()
  return result
end

-- this dedub favors the latest occuring element
M.dedup = function(t)
  local result = {}
  local seen = {}
  for i = #t, 1, -1 do
    local v = t[i]
    if not seen[v] then
      table.insert(result, 1, v)
      seen[v] = true
    end
  end

  return result
end

M.tail_n = function(t, n)
  local result = {}
  local len = #t
  for i = len - n + 1, len do
    table.insert(result, t[i])
  end

  return result
end

return M
