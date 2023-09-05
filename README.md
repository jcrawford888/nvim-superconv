# nvim-superconv

## What is nvim-superconv?

Do you ever find yourself having to convert some time units to seconds to 
stick into a config file (e.g. 2 hours to seconds) or converting MB units
into bytes?

This plugin is for you.  It can be used to read the units from your current
buffer and convert to the units you need, right in place.

## Getting Started

Use your preferred plugin manager to install the plugin in neovim then see
the Usage section below.

## Installation

Using `packer`

```lua
use { "jcrawford888/nvim-superconv" }
```

Using `lazy.nvim`

```lua
{ "jcrawford888/nvim-superconv" }
```


## Usage

You can run the commands directly as lua commands as follows:

```lua
:lua require("nvim-superconv").conv_bytes()
```

or use the command

```lua
:Superconv conv_bytes
```

It's recommended to make a key map for frequently used commands.

```lua
vim.keymap.set('n', '<leader>scb', "<cmd>lua require("nvim-superconv").conv_bytes()", { silent = true, noremap = true })
or
vim.keymap.set('n', '<leader>scb', "<cmd>:Superconv conv_bytes<cr>", { silent = true, noremap = true })
```
