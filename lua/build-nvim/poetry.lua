local utils = require("build-nvim.utils")

return {
    setup = function (opts)
        local env = vim.fn.trim(vim.fn.system("poetry env activate"))
        utils.define_setup(env .. "&&poetry lock&&poetry install", nil, opts.post_setup)
    end
}
