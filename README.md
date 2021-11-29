# run-code

A simple plugin to quickly run a snippet of code without ever leaving neovim. This is especially useful when you are writing/debugging scripts

## Installation

Use you faviorite plugin manager. If you use vim-plug, add this to your `init.vim` / `init.lua`

```vim
Plug 'arjunmahishi/run-code.nvim'
```
## Demo

#### Running the whole file / Run selective snippets

![run-code-1](https://user-images.githubusercontent.com/11977524/143928407-5b440a4f-fd7b-440c-940a-088ac1006a85.gif)

#### Running code snippets within a markdown file

![run-code-2](https://user-images.githubusercontent.com/11977524/143929192-3c43f4c6-a3bc-4775-b561-c1d78bc8925b.gif)

## Usage

This is still a work in progress. So, PRs are welcome and appreciated. As of now, this plugin can do the following things

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

---

If you have any questions about how to use the plugin or need help understanding the code, feel free to [get in touch on twitter](https://twitter.com/messages/131552332-131552332?text=Hey)
