-- TODO: validate if these commands are available
lang_cmd_map = {
  lua = "lua <<-EOF\n%s\nEOF",
  -- python = "python3 <<-EOF\n%s\nEOF",
  ruby = "ruby <<-EOF\n%s\nEOF",
  bash = "bash <<-EOF\n%s\nEOF",
  sh = "sh <<-EOF\n%s\nEOF",
  scheme = "scheme <<-EOF\n%s\nEOF" --TODO: try to clean up the output
}

function cmd(lang, code)
  local cmd_tmpl = lang_cmd_map[lang]
  if cmd_tmpl == nil then
    return ""
  end

  return string.format(cmd_tmpl, code)
end

return {
  cmd = cmd
}
