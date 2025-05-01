local utils = require("build-nvim.utils")

return {
    condition = function()
        return #vim.fn.glob("{settings,build}.gradle*") > 0
    end,
    setup = function(opts)
        if opts.post_setup then opts.post_setup() end
    end
}
