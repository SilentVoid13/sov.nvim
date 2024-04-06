# sov.nvim

sov.nvim is an integration of the [sov](https://github.com/SilentVoid13/sov) Language Server for Neovim.

## Usage

```lua
require("sov").setup({
    root_dir = '<personal_knowledge_dir>'
})
```

sov.nvim will automatically start the [sov](https://github.com/SilentVoid13/sov) Language Server on markdown files opening.

## Commands

sov.nvim defines the following commands:
- `SovIndex`
- `SovDaily`
- `SovScriptRun`
- `SovScriptInsert`
- `SovFindFiles`
- `SovFuzzySearch`
