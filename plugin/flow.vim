if exists('g:loaded_flow') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! FlowRunFile lua require('flow').run_file()
command! -nargs=? FlowSetCustomCmd lua require('flow.cmd').set_custom_cmd(<f-args>)
command! -nargs=? FlowRunCustomCmd lua require('flow').run_custom_cmd(<f-args>)
command! FlowReload lua require('flow').reload_plugin()
command! -nargs=* -range FlowRunSelected call luaeval("require('flow').run_range(_A)", [<line1>, <line2>, <count>, <f-args>])
command! FlowLauncher lua require('flow.telescope').custom_cmds()
command! FlowRunLastCmd lua require('flow').run_last_custom_cmd()
command! FlowLastOutput lua require('flow').show_last_output()


" the below commands have been renamed to the above ones. Just keeping them
" for some time to maintain backward compatibility
command! RunCodeBlock lua require('flow').run_block()
command! RunCodeFile lua require('flow').run_file()
command! -nargs=? RunCodeSetCustomCmd lua require('flow.cmd').set_custom_cmd(<f-args>)
command! -nargs=? RunCodeCustomCmd lua require('flow').run_custom_cmd(<f-args>)
command! ReloadRunCode lua require('flow').reload_plugin()
command! -nargs=* -range RunCodeSelected call luaeval("require('flow').run_range(_A)", [<line1>, <line2>, <count>, <f-args>])
command! RunCodeLauncher lua require('flow.telescope').custom_cmds()
command! RunCodeLastCustomCmd lua require('flow').run_last_custom_cmd()
command! RunCodeLastOutput lua require('flow').show_last_output()

" trigger reset of output when the output buffer is manually closed
autocmd FileType run-code-output autocmd BufDelete <buffer> lua require('flow.output').reset_output_win()

" close the custom command window on save
autocmd BufWritePost,BufLeave,BufDelete *run_code_custom_cmd_* lua require('flow.cmd').close_custom_cmd_win()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_flow = 1
