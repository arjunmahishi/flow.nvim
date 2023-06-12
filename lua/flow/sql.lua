-- this file generates the command to execute SQL queries

local cmd_tmpl = {
  postgres = 'psql "postgres://%s:%s@%s:%s/%s?sslmode=disable" <<-EOF\n%s\nEOF'
}

local M = {}

M.default_config = nil
M.configs = {}
-- sample config:
--
-- [
--    {
--      "type": "postgres",
--      "user": "postgres",
--      "password": "postgres",
--      "host": "localhost",
--      "port": "5432",
--      "db": "db_name"
--    }
-- ]

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

M.set_default_config = function(config)
  M.default_config = config
end

return M
