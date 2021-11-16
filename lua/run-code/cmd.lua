lang_cmd_map = {
  lua = "lua <<-EOF\n%s\nEOF"
}

function cmd(block)
  local cmd_tmpl = lang_cmd_map[block.lang]
  if cmd_tmpl == nil then
    return ""
  end

  return string.format(cmd_tmpl, block.code)
end

return {
  cmd = cmd
}
