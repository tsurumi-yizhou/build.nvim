# build.nvim
## Introduction
This Neovim Plugin provides a simple and unified interface to setup and build your projects.

## Requirements
Install `xml2lua` through `luarocks`.

## Configuration
```lua
return {
    "tsurumi-yizhou/build.nvim",
    dependencies = {
        "akinsho/toggleterm.nvim",
    },
    config = function()
        require("build-nvim").setup {
            setup_at_start = true,
            cmake = {
                post_setup = function(build_dir)  end,
                post_build = function()  end,
            },
            poetry = {
                post_setup = function(env, exe, path)  end,
                post_build = function()  end,
            },
            astro = {
                post_setup = function(tsserver, runtime)  end,
                post_build = function()  end,
            },
            dotnet = {
                post_setup = function(languages)  end,
                post_build = function()  end
            }
        }
    end,
}
```
You can naturally setup your LSP in `post_setup` function.

Use bun for typescript runtime by default.

## Roadmap
- [ ] Add more build systems
