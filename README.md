# run-code

A simple plugin to quickly run a snippet of code without ever leaving neovim. This is especially useful when you are writing/debugging scripts

## Installation

Use you favorite plugin manager. If you use vim-plug, add this to your `init.vim` / `init.lua`

```vim
Plug 'arjunmahishi/run-code.nvim'
```

## Usage

This is still a work in progress. So, PRs are welcome and appreciated. As of now, this plugin can do the following things

| Command | Description |
|---------|-------------|
| `:RunCodeSelected` | Run code that is visually selected |
| `:RunCodeFile` | Run the entire file |
| `:RunCodeBlock` | Run a code snippet present in markdown (place the cursor within the snippet and run the command) |
| `:RunCodeSetCustomCmd <alias>` | Set a custom commands to use with `:RunCodeCustomCmd`. This custom command would be used instead of the default run command used for a specific language |
| `:RunCodeCustomCmd <alias>` | Run the custom command stored at the given alias |

##### Some useful key bindings

```lua
-- paste this in your init.lua

vim.api.nvim_set_keymap('v', '<leader>r', ':RunCodeSelected<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>rr', ':RunCodeFile<CR>', {})

-- set custom commands
vim.api.nvim_set_keymap('n', '<leader>R1', ':RunCodeSetCustomCmd 1<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>R2', ':RunCodeSetCustomCmd 2<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>R3', ':RunCodeSetCustomCmd 3<CR>', {})

-- run custom commands
vim.api.nvim_set_keymap('n', '<leader>r1', ':RunCodeCustomCmd 1<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>r2', ':RunCodeCustomCmd 2<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>r3', ':RunCodeCustomCmd 3<CR>', {})
```

OR (in vim script)

```vim
" paste this in your init.vim

vmap <leader>r :RunCodeSelected<CR>
nmap <leader>rr :RunCodeFile<CR>

" set custom commands
nmap <leader>R1 :RunCodeSetCustomCmd 1<CR>
nmap <leader>R2 :RunCodeSetCustomCmd 2<CR>
nmap <leader>R3 :RunCodeSetCustomCmd 3<CR>

" run custom commands
nmap <leader>r1 :RunCodeCustomCmd 1<CR>
nmap <leader>r2 :RunCodeCustomCmd 2<CR>
nmap <leader>r3 :RunCodeCustomCmd 3<CR>
```

## Configuration

```lua
require('run-code').setup {
  output = {
    buffer = true,
    split_cmd = '20split',
  }
}

-- optional custom variables
require('run-code.vars').add_vars({
  str = "test-val-2",
  num = 3,
  bool = true,
  var_with_func = function()
    -- the value of this var is computed by running this function at runtime
    return "test-val"
  end
})
```

| Attributes | Default | Description |
|------------|---------|-------------|
| `output` | `{}` | Configuration for how the output is presented |


#### Output options

| Option | Default | Description |
|--------|---------|-------------|
| `buffer` | `false` | Whether to print the output in a buffer or not. By default the output is printed in the command window. If this option is set to `true`, the output will be shown in a separate buffer |
| `split_cmd` | `vsplit` | Configure how the output buffer should be created. For now, only split buffers are supported. Possible values for this option are `split`, `vsplit`, `nsplit`, `nvsplit`. Where `n` is  the hight/width of the split buffer |

## Demo

#### Running the whole file / Run selective snippets

![run-code-1](https://user-images.githubusercontent.com/11977524/143928407-5b440a4f-fd7b-440c-940a-088ac1006a85.gif)

#### Running code snippets within a markdown file

![run-code-2](https://user-images.githubusercontent.com/11977524/143929192-3c43f4c6-a3bc-4775-b561-c1d78bc8925b.gif)

---

If you have any questions about how to use the plugin or need help understanding the code, feel free to [get in touch on twitter](https://twitter.com/messages/131552332-131552332?text=Hey)
