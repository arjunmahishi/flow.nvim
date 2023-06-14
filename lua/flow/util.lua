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

return M
