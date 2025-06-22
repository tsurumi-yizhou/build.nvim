# build.nvim
A neovim plugin that helps you build your project.

## Installation
```lua
return {
    "tsurumi-yizhou/build.nvim",
    dependencies = {
        "stevearc/overseer.nvim",
    },
    keys = {
      { "<leader>b", ":lua require(\"build-nvim\").build(vim.input())", desc = "Build" },
      { "<leader>c", require("build-nvim").clean, desc = "Clean" },
      { "<leader>s", require("build-nvim").stop, desc = "Stop" },
    },
    opts = {
        auto_show = true,
        overseer_components = {...}
    }
}
```

## Usage
### Adapters
```lua
require("build-nvim").adapters.cmake = {
    type = "Release",
    directory = "build",
    build = function(target_name)
        ......
    end,
    clean = function()
        ......
    end,
}
```
### Configurations
#### Binary
```lua
require("build-nvim").configurations["main"] = {
    name = "A Binary Target",
    type = "executable",
    adapter = "cmake",
    options = "-j4", 
}

require("build-nvim").configurations["dependency"] = {
    name = "A Library Target",
    type = "library",
    adapter = "cmake",
    options = "-j4",
}
```
#### Distributable
```lua
require("build-nvim").configurations["blog"] = {
    name = "My Blog Website",
    type = "distributable",
    adapter = "vite",
    options = "",
}
```
