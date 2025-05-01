local systems = { "cmake", "poetry", "lua", "dotnet", "astro", "vite", "gradle" }

return {
    setup = function(opts)
        vim.api.nvim_create_user_command("Setup", function()
            for _, name in ipairs(systems) do
                local module = require("build-nvim." .. name)
                if module.condition() then
                    if opts[name] then
                        module.setup(opts[name])
                    else
                        module.setup({})
                    end
                end
            end
        end, {})
        if opts.setup_at_start == true then
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    vim.cmd("Setup")
                end
            })
        end
    end
}
