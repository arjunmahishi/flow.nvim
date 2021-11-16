if exists('g:loaded_run_code') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! RunCode lua require'run-code'.run()
command! ReloadRunCode lua require'run-code'.reload_plugin()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_run_code = 1
