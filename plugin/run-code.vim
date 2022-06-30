if exists('g:loaded_run_code') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! RunCodeBlock lua require('run-code').run_block()
command! RunCodeFile lua require('run-code').run_file()
command! -nargs=? RunCodeSetCustomCmd lua require('run-code.cmd').set_custom_cmd(<f-args>)
command! -nargs=? RunCodeCustomCmd lua require('run-code').run_custom_cmd(<f-args>)
command! ReloadRunCode lua require('run-code').reload_plugin()
command! -nargs=* -range RunCodeSelected call luaeval("require('run-code').run_range(_A)", [<line1>, <line2>, <count>, <f-args>])

" trigger reset of output when the output buffer is manually closed
autocmd FileType run-code-output autocmd BufDelete <buffer> lua require('run-code.output').reset_output_win()

" close the custom command window on save
autocmd BufWritePost,BufLeave,BufDelete *run_code_custom_cmd_* lua require('run-code.cmd').close_custom_cmd_win()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_run_code = 1
