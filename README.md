# run-code

A simple plugin to run code blocks present in markdown files

## Installation

Use you faviorite plugin manager. If you use vim-plug, add this to your `init.vim` / `init.lua`

```vim
Plug 'arjunmahishi/run-code.nvim'
```

## Usage

Place the cursor over a code block in a markdown file and run the command `:RunCode`

You could alternatively add a key mapping to do that same
```vim
au filetype markdown nmap <leader>r :RunCode<CR>
```
