-- TODO: validate if these commands are available
lang_cmd_map = {
  lua = "lua %s <<-EOF\n%s\nEOF",
  python = "python %s <<-EOF\n%s\nEOF",
  ruby = "ruby %s <<-EOF\n%s\nEOF",
  bash = "bash %s <<-EOF\n%s\nEOF",
  sh = "sh %s <<-EOF\n%s\nEOF",
  scheme = "scheme %s <<-EOF\n%s\nEOF" --TODO: try to clean up the output
}

-- constructs a command in the following format:
--
-- <binary to run> 2> <output_file> 1>> <output_file> <<-EOF
--    <code>
-- EOF
--
function cmd(lang, code, output_file)
  local redirect_str = string.format("2> %s 1>> %s", output_file, output_file)
  local cmd_tmpl = lang_cmd_map[lang]
  if cmd_tmpl == nil then
    return ""
  end

  return string.format(cmd_tmpl, redirect_str, code)
end

return {
  cmd = cmd
}
