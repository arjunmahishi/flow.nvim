-- this file generates the command to execute SQL queries

local cmd_tmpl = {
  postgres = 'psql "postgres://%s:%s@%s:%s/%s?sslmode=disable" <<-EOF\n%s\nEOF'
}

local M = {}

M.configs = {}

M.cmd = function(query)
  if #M.configs == 0 then
    print("flow: no database config found. See this to learn how to configure it: ")
    return nil
  end

  local config = M.configs[1]
  local cmd = cmd_tmpl[config.type]
  if cmd == nil then
    print("flow: sorry! currently only postgres is supported")
    return nil
  end

  return string.format(
    cmd, config.user, config.password, config.host, config.port, config.db, query
  )
end

return M
