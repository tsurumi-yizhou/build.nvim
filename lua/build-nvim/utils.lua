local terminal = require("toggleterm.terminal").Terminal

local popup = function(command, on_exit)
    terminal:new({
        direction = "float",
        cmd = command,
        hidden = false,
        close_on_exit = false,
        on_exit = function(term, _, code, _)
            if code == 0 then
                term:close()
                if on_exit ~= nil then on_exit() end
            end
        end
    }):toggle()
end

return {
    define_setup = function(command, pre, post)
        vim.api.nvim_create_user_command("Setup", function()
            if pre ~= nil then pre() end
            popup(command, post)
        end, {})
    end,

    define_single_build = function (command, pre, post)
        vim.api.nvim_create_user_command("Build", function ()
            if pre ~= nil then pre() end
            popup(command, post)
        end, {})
    end,

    define_multi_build = function (pre, post, opts)
        vim.api.nvim_create_user_command("BuildAll", function ()
            if pre ~= nil then pre() end
            popup(opts.build_all, post)
        end, {})

        vim.api.nvim_create_user_command("Build", function ()
            if pre ~= nil then pre() end
            vim.ui.select(opts.build_targets, {
                prompt = opts.prompt or "Select Target",
                format = opts.formatter or function (item)
                    return "→ " .. item
                end
            }, function (choice, index)
                if not choice then return end
                local item = opts.build_targets[index]
                if type(opts.build_one) == "function" then
                    popup(opts.build_one(item), post)
                elseif type(opts.build_one) == "string" then
                    popup(string.format(opts.build_one, item), post)
                end
            end)
        end, {})
    end
}
