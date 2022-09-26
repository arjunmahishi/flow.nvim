# flow.nvim

A lightweight neovim plugin to quickly run a snippet of code (in the context of the current file you’re editing) without ever leaving neovim. Gives you a slight boost in productivity by helping you automate parts of your development workflow. Has a pretty cool integration with telescope

## Installation

Use you favorite plugin manager. If you use vim-plug, add this to your `init.vim` / `init.lua`

```vim
Plug 'arjunmahishi/flow.nvim'
```

## Usage

This is still a work in progress. So, PRs are welcome and appreciated. As of now, this plugin can do the following things

| Command | Description |
|---------|-------------|
| `:FlowRunSelected` | Run code that is visually selected |
| `:FlowRunFile` | Run the entire file |
| `:FlowSetCustomCmd <alias>` | Set a custom commands to use with `:FlowRunCustomCmd`. This custom command would be used instead of the default run command used for a specific language |
| `:FlowRunCustomCmd <alias>` | Run the custom command stored at the given alias |
| `:FlowLauncher` | Launches a [telescope](https://github.com/nvim-telescope/telescope.nvim) interface to manage custom commands. Read the docs [here](https://github.com/arjunmahishi/flow.nvim/wiki/Run-code-launcher) |
| `:FlowRunLastCmd` | Run the previously executed custom command |
| `:FlowLastOutput` | Show the output of the last run command |

## Custom commands

Custom commands are snippets of code you can map to an alias to access and run
them easily. Custom commands can be created using either `:FlowSetCustomCmd`
or `FlowLauncher`. `:FlowLauncher` uses a nice telescope interface which
makes it easy to manage the commands. So, `:FlowLauncher` is recommended
over `:FlowSetCustomCmd`.

Running `:FlowSetCustomCmd <alias>` launches a special buffer which allows
you to create a custom command snippet. This buffer automatically closes on
saving. This remains same even if you are using `:FlowLauncher`. Once the
command snippet is saved, it is available to be executed using the alias you
have mapped it to.

#### Custom variables

Custom commands, at the end of the day, are executed using the shell. So,
here's a list of `ENV` variables that are available to use while writing the
command snippets. 

| Variable | Value |
|----------|-------|
| `pwd` | the directory where vim/nvim was launched |
| `curr_file` | the path of the current file you are editing |

The intention of this is to give the command snippets some context of the code
you are currently writing. You can create some of your own variables by
declaring them in the plugin configuration (refer to the configuration examples
below)

Find the docs for `:FlowLauncher` [here](https://github.com/arjunmahishi/flow.nvim/wiki/Run-code-launcher)

## Configuration

```lua
require('flow').setup {
  output = {
    buffer = true,
    split_cmd = '20split',
  },

  -- add/override the default command used for a perticular filetype
  -- the "%s" you see in the below example is interpolated by the contents of
  -- the file you are trying to run
  -- Format { <filetype> = <command> }
  filetype_cmd_map = {
    python = "python3 <<-EOF\n%s\nEOF",
  }
}

-- optional custom variables
require('flow.vars').add_vars({
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

![flow-1](https://user-images.githubusercontent.com/11977524/143928407-5b440a4f-fd7b-440c-940a-088ac1006a85.gif)

#### Some useful key bindings

```lua
-- paste this in your init.lua

vim.api.nvim_set_keymap('v', '<leader>r', ':FlowRunSelected<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>rr', ':FlowRunFile<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>rt', ':FlowLauncher<CR>', {})

-- set custom commands
vim.api.nvim_set_keymap('n', '<leader>R1', ':FlowSetCustomCmd 1<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>R2', ':FlowSetCustomCmd 2<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>R3', ':FlowSetCustomCmd 3<CR>', {})

-- run custom commands
vim.api.nvim_set_keymap('n', '<leader>r1', ':FlowRunCustomCmd 1<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>r2', ':FlowRunCustomCmd 2<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>r3', ':FlowRunCustomCmd 3<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>rp', ':FlowRunLastCmd<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>rp', ':FlowLastOutput<CR>', {})
```

OR (in vim script)

```vim
" paste this in your init.vim

vmap <leader>r :FlowRunSelected<CR>
nmap <leader>rr :FlowRunFile<CR>
nmap <leader>rt :FlowLauncher<CR>

" set custom commands
nmap <leader>R1 :FlowSetCustomCmd 1<CR>
nmap <leader>R2 :FlowSetCustomCmd 2<CR>
nmap <leader>R3 :FlowSetCustomCmd 3<CR>

" run custom commands
nmap <leader>r1 :FlowRunCustomCmd 1<CR>
nmap <leader>r2 :FlowRunCustomCmd 2<CR>
nmap <leader>r3 :FlowRunCustomCmd 3<CR>
nmap <leader>rp :FlowRunLastCmd<CR>
nmap <leader>ro :FlowLastOutput<CR>
```

---

If you have any questions about how to use the plugin or need help understanding the code, feel free to [get in touch on twitter](https://twitter.com/messages/131552332-131552332?text=Hey)
