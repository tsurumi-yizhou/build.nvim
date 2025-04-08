local usercmd = vim.api.nvim_create_user_command
local utils = require("build-nvim.utils")

return {
    setup = function (opts)
        local build_dir = opts.build_dir or "build"
        local setup_command = string.format("cmake -S . -B %s ", build_dir)
        if opts.generator then
            setup_command = setup_command .. string.format("-G %s ", opts.generator)
        elseif type(opts.preset) == "string" then
            setup_command = setup_command .. string.format("--preset %s ", opts.preset)
        elseif type(opts.preset) == "function" then
            setup_command = setup_command .. string.format("--preset %s ", opts.preset())
        end

        usercmd("Setup", function ()
            utils.popup(setup_command, opts.post_setup)
        end, {})

        usercmd("Build", function (target)
            local build_command = string.format("cmake --build %s ", build_dir)
            if type(target.args) == "string" and #target.args > 0 then
                build_command = string.format("%s --target %s ", build_command, target.args)
            end
            utils.popup(build_command, opts.post_build)
        end, { nargs = "?" })
    end
}
