# run-code

A simple plugin to quickly run a snippet of code without ever leaving the nvim. This is especially useful when you are writing/debugging scripts

## Installation

Use you faviorite plugin manager. If you use vim-plug, add this to your `init.vim` / `init.lua`

```vim
Plug 'arjunmahishi/run-code.nvim'
```

## Usage

This is still a work in progress. There are still a couple of bugs that make it slightly unusable. So, PRs are welcome and appreciated. As of now, this plugin can do the following things

| Command | Description |
|---------|-------------|
| `:RunCodeSelected` | Run code that is visually selected |
| `:RunCodeFile` | Run the entire file |
| `:RunCodeBlock` | Run a code snippet present in markdown (place the cursor within the snippet and run the command) |

##### Some useful key bindings

```lua
-- paste this in your init.lua

vim.api.nvim_set_keymap('v', '<leader>r', ':RunCodeSelected<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>r', ':RunCodeFile<CR>', {})
vim.cmd [[
  au filetype markdown nmap <leader>R :RunCodeBlock<CR>
]]
```

OR (in vim script)

```vim
" paste this in your init.vim

vmap <leader>r :RunCodeSelected<CR>
nmap <leader>r :RunCodeFile<CR>
au filetype markdown nmap <leader>R :RunCodeBlock<CR>
```
