# run-code

A simple plugin to run code from within nvim without ever leaving the editor

## WIP

This is still a work in progress. There are still a couple of bugs that make it slightly unusable. So, PRs are welcome and appreciated. As of now, this plugin can do the following things

- Run code that is visually selected (`:RunCodeSelected`)
- Run the entire file (`:RunCodeFile`)
- Run a code snippet present in markdown (hover over the snippet you want to run and `:RunCodeBlock`)

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
