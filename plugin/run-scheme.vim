if exists('g:loaded_run_scheme') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! RunScheme lua require'run-scheme'.run()
command! ReloadRunScheme lua require'run-scheme'.reload_plugin()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_run_scheme = 1
