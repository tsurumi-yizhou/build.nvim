local usercmd = vim.api.nvim_create_user_command
local utils = require("build-nvim.utils")

return {
    setup = function (opts)
        usercmd("Setup", function ()
            utils.popup("bun install", opts.post_setup)
        end, {})
        usercmd("Build", function()
            utils.popup("bun run build", opts.post_build)
        end, {})
    end
}
