# nvim-superconv

## What is nvim-superconv?

Do you ever find yourself having to convert some time units to seconds to 
stick into a config file (e.g. 2 hours to seconds) or converting MB units
into bytes?

This plugin is for you.  It can be used to read the units from your current
buffer and convert to the units you need, right in place.

## Getting Started


## Installation


### checkhealth

## Usage

Try the command `:Superconv seconds<cr>`
  to see if `nvim-superconv.nvim` is installed correctly.

Using VimL:

```viml
" TODO
nnoremap <leader>scs <cmd>Superconv seconds<cr>

" Using Lua functions
nnoremap <leader>scs <cmd>lua require('nvim-superconv').conv_sec()<cr>
```

Using Lua:

```lua
local builtin = require('nvim-superconv')
vim.keymap.set('n', '<leader>scs', builtin.conv_sec, {})
```
