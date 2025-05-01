local utils = require("build-nvim.utils")

return {
    condition = function()
        if vim.uv.fs_stat(".luarc.json") then
            return true
        end
        if vim.uv.fs_stat("lua") then
            return true
        end
        return false
    end,
    setup = function(opts)
        local config = utils.read_config {
            libraries = { vim.env.VIMRUNTIME }
        }
        if opts.post_setup then
            opts.post_setup(config.libraries)
        end
    end
}
