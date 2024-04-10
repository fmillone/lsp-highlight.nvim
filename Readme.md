# LSP-Highlight.nvim

This plugin highlights the variable under the cursor in the open file. Inspired by the same feature from `navigator.nvim`

## Install with lazy

```lua
{ 'fmillone/lsp-highlight.nvim', opts = {} }
```

## Usage

Put the cursor over the variable you want to highlight and type `<leader>k`.

To clear all the highlighted references use `<leader>K`

## TODOS

* [X] make keymaps configurable
* [ ] make highlight group configurable
* [ ] clear highlight for a single variable (toggle)
