if exists('g:loaded_run_code') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! RunCodeBlock lua require'run-code'.run_block()
command! RunCodeFile lua require'run-code'.run_file()
command! ReloadRunCode lua require'run-code'.reload_plugin()
command! -nargs=* -range RunCodeSelected call luaeval("require('run-code').run_range(_A)", [<line1>, <line2>, <count>, <f-args>])

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_run_code = 1
