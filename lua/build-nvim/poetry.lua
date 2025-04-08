local usercmd = vim.api.nvim_create_user_command
local utils = require("build-nvim.utils")

return {
    setup = function (opts)
        usercmd("Setup", function ()
            local env = vim.fn.trim(vim.fn.system("poetry env activate"))
            utils.popup(env .. "&&poetry install", opts.post_setup)
        end, {})
    end
}
