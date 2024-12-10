-- Check if the plugin is already loaded
if vim.g.loaded_flow then
  return
end

-- Commands
vim.api.nvim_create_user_command('FlowRunFile', function()
  require('flow').run_file()
end, {})

vim.api.nvim_create_user_command('FlowSetCustomCmd', function(opts)
  require('flow.cmd').set_custom_cmd(opts.args)
end, { nargs = '?' })

vim.api.nvim_create_user_command('FlowRunCustomCmd', function(opts)
  require('flow').run_custom_cmd(opts.args)
end, { nargs = '?' })

vim.api.nvim_create_user_command('FlowReload', function()
  require('flow').reload_plugin()
end, {})

vim.api.nvim_create_user_command('FlowRunSelected', function(opts)
  require('flow').run_range({ opts.line1, opts.line2 })
end, { nargs = '*', range = true })

vim.api.nvim_create_user_command('FlowLauncher', function()
  require('flow.telescope').custom_cmds()
end, {})

vim.api.nvim_create_user_command('FlowRunLastCmd', function()
  require('flow').run_last_custom_cmd()
end, {})

vim.api.nvim_create_user_command('FlowLastOutput', function()
  require('flow').show_last_output()
end, {})

vim.api.nvim_create_user_command('FlowRunMDBlock', function()
  require('flow').run_block()
end, {})

vim.api.nvim_create_user_command('FlowRunQuickCmd', function()
  require('flow').run_quick_cmd()
end, {})

-- Autocommand
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'run-code-output',
  callback = function()
    vim.api.nvim_create_autocmd('BufDelete', {
      callback = function()
        require('flow.output').reset_output_win()
      end,
    })
  end,
})

-- Mark the plugin as loaded
vim.g.loaded_flow = 1
