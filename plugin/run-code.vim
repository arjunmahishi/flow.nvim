if exists('g:loaded_run_code') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! RunCode lua require'run-code'.run()
command! ReloadRunCode lua require'run-code'.reload_plugin()

" this is only for debugging
au filetype markdown nmap <leader>r :RunCode<CR>

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_run_code = 1
