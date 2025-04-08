# build.nvim
## Introduction
This Neovim Plugin provides a simple and unified interface to setup and build your projects.

## Configuration
```lua
return {
    "tsurumi-yizhou/build.nvim",
    dependencies = {
        "akinsho/toggleterm.nvim",
    },
    config = function()
        require("build-nvim").setup {
            cmake = {
                build_dir = "build",
                post_setup = function()  end,
                post_build = function()  end,
            },
            poetry = {
                post_setup = function()  end,
                post_build = function()  end,
            },
            --- Astro.js
            astro = {
                post_setup = function()  end,
                post_build = function()  end,
            },
            dotnet = {
                post_setup = function()  end,
                post_build = function()  end
            }
        }
    end,
}
```
You can naturally setup your LSP in `post_setup` function.

## Roadmap
- [ ] Add more build systems