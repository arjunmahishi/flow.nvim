# flow.nvim

[![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io/)
[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
![Usage](https://go-badges.vercel.app/api/nvim-plugin-usage?username=arjunmahishi&repo=flow.nvim)

A lightweight neovim plugin to quickly run a snippet of code (in the context of the current file you’re editing) without ever leaving neovim. Gives you a slight boost in productivity by helping you automate parts of your development workflow. Has a pretty cool integration with telescope

## Table of contents

<!-- toc -->

- [Demo](#demo)
- [Installation](#installation)
- [Usage](#usage)
- [Custom commands](#custom-commands)
    + [Custom variables](#custom-variables)
- [Configuration](#configuration)
    + [`output` options](#output-options)
    + [Sample dB config file](#sample-db-config-file)
- [Some useful key bindings](#some-useful-key-bindings)

<!-- tocstop -->

## Demo

It's hard to do justice to this plugin by explaining what it does, in text form. [**Watch the demo here**](https://www.youtube.com/watch?v=GE5E1ZhV_Ok).

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
| `:FlowLauncher` | Launches a [telescope](https://github.com/nvim-telescope/telescope.nvim) interface to manage custom commands. Read the docs [here](https://github.com/arjunmahishi/flow.nvim/wiki/Flow-launcher) |
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

Find the docs for `:FlowLauncher` [here](https://github.com/arjunmahishi/flow.nvim/wiki/Flow-launcher)

## Configuration

```lua
require('flow').setup {
    output = {
        buffer = true,
        size = 80, -- possible values: "auto" (default) OR 1-100 (percentage of screen to cover)
        focused = true,
        modifiable = false,

        -- window_override = {
        --   border = 'double',
        --   title = 'Output',
        --   title_pos = 'center',
        --   style = 'minimal',
        --   ...
        -- }
    },

    -- add/override the default command used for a perticular filetype
    -- the "%s" you see in the below example is interpolated by the contents of
    -- the file you are trying to run
    -- Format { <filetype> = <command> }
    filetype_cmd_map = {
        python = "python3 <<-EOF\n%s\nEOF",
    },

    -- optional DB configuration for running .sql files/snippets (experimental)
    sql_configs = require('flow.util').read_sql_config('/Users/arjunmahishi/.db_config.json')

    -- configure a directory for storing all the custom commands
    custom_cmd_dir = "/Users/arjunmahishi/.flow_cmds"
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
| `filetype_cmd_map` | `{}` | add/override the default command used for a particular filetype |
| `sql_configs` | `nil` | optional DB configuration for running .sql files/snippets _(experimental)_ |


#### `output` options

| Option | Default | Description |
|--------|---------|-------------|
| `buffer` | `true` | Whether to print the output in a floating buffer or not. If this option is set to `false`, the output will be shown in the command window |
| `size` | `auto` | `auto` or `1-100` (percentage of screen to cover) |
| `focused` | `true` | If this is set to `false`, the focus will be set back to your current working window |
| `modifiable` | `false` | If this is set to `true`, the output buffer will be editable |
| `window_override` | `{}` | You can override one or more attributes of the output window config. This can work in conjunction with `size`. Check the available parameters in `:help api-win_config` |
| `split_cmd` (deprecated) | `vsplit` | Configure how the output buffer should be created. For now, only split buffers are supported. Possible values for this option are `split`, `vsplit`, `nsplit`, `nvsplit`. Where `n` is  the hight/width of the split buffer |

#### Sample dB config file

⚠️  This is still experimental

`.db_config.json`

```
[
   {
     "type": "postgres",
     "user": "postgres",
     "password": "password",
     "host": "localhost",
     "port": "5432",
     "db": "flow_nvim_test_db"
   }
]
```

## Some useful key bindings

```lua
-- paste this in your init.lua

vim.api.nvim_set_keymap('v', '<leader>r', ':FlowRunSelected<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>rr', ':FlowRunFile<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>rt', ':FlowLauncher<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>rp', ':FlowRunLastCmd<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>rp', ':FlowLastOutput<CR>', {})
```

OR (in vim script)

```vim
" paste this in your init.vim

vmap <leader>r :FlowRunSelected<CR>
nmap <leader>rr :FlowRunFile<CR>
nmap <leader>rt :FlowLauncher<CR>
nmap <leader>rp :FlowRunLastCmd<CR>
nmap <leader>ro :FlowLastOutput<CR>
```

---

If you have any questions about how to use the plugin or need help understanding the code, feel free to [get in touch on twitter](https://twitter.com/messages/131552332-131552332?text=Hey)
