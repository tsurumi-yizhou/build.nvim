local usercmd = vim.api.nvim_create_user_command
local utils = require("build-nvim.utils")

return {
    setup = function(opts)
        usercmd("Setup", function()
            utils.popup("dotnet restore", opts.post_setup)
        end, {})

        usercmd("Build", function(target)
            local build_command = "dotnet build "
            if type(target.args) == "string" and #target.args > 0 then
                build_command = build_command .. target.args
            end
            utils.popup(build_command, opts.post_build)
        end, { nargs = "?" })
    end
}