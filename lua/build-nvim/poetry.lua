local utils = require("build-nvim.utils")

return {
    condition = function()
        if #vim.fn.glob("poetry.lock") > 0 then
            return true
        end
        if #vim.fn.glob("pyproject.toml") > 0 then
            local file = io.open("pyproject.toml", "r")
            for line in file:lines() do
                if string.find(line, "poetry", 1, true) then
                    file:close()
                    return true
                end
            end
        end
        return false
    end,
    setup = function(opts)
        local command = vim.fn.system("poetry env use")
        local executable = vim.fn.system("poetry env info --executable")
        local environment = vim.fn.system("poetry env info --path")

        local config = utils.read_config {
            env = vim.fn.trim(command),
            exe = vim.fn.trim(executable),
            path = vim.fn.trim(environment)
        }

        if opts.post_setup then
            opts.post_setup(config.env, config.exe, config.path)
        end
    end
}
