local popup = function(commad, post)
    require("toggleterm.terminal").Terminal:new {
        direction = "float",
        cmd = commad,
        hidden = false,
        close_on_exit = false,
        on_exit = function(term, _, code, _)
            if code == 0 then
                if post then post() end
                term:close()
            end
        end
    }:toggle()
end

return {
    popup = popup,
    register = function(targets, post_build)
        local candidates = {}
        for _, target in ipairs(targets) do
            candidates[#candidates + 1] = target.name
        end
        vim.build.current = candidates[1]
        vim.api.nvim_create_user_command("Build", function(arg)
            if arg and arg.args and #arg.args > 0 then
                for _, target in ipairs(targets) do
                    if target.name == arg.args then
                        popup(target.command, post_build)
                    end
                end
            else
                for _, target in ipairs(targets) do
                    if target.name == vim.build.current then
                        popup(target.command, post_build)
                    end
                end
            end
        end, {
            nargs = "?",
            complete = function()
                return candidates
            end
        })
        vim.api.nvim_create_user_command("SelectBuildTarget", function()
            vim.ui.select(candidates, {
                prompt = "Select Build Target",
                format_item = function(item)
                    return "Build " .. item .. "\n"
                end
            }, function(choice)
                vim.build.current = choice
            end)
        end, { nargs = 0 })
    end,
    read_config = function(default)
        local dir = vim.fs.joinpath(vim.fn.getcwd(), ".nvim")
        local path = vim.fs.joinpath(dir, "config.json")
        vim.fn.mkdir(dir, "p")
        if #vim.fn.glob(path) > 0 then
            local file = io.open(path, "r")
            local config = vim.json.decode(file:read("*a"))
            file:close()
            return config
        else
            local file = io.open(path, "w")
            file:write(vim.json.encode(default))
            file:close()
            return default
        end
    end
}
