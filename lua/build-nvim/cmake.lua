local utils = require("build-nvim.utils")

local create_file = function(build_dir)
    local dir = vim.fs.joinpath(build_dir, ".cmake", "api", "v1", "query", "nvim")
    vim.fn.mkdir(dir, "p")
    local file = io.open(vim.fs.joinpath(dir, "query.json"), "w")
    local content = vim.json.encode {
        requests = {
            {
                kind = "codemodel",
                version = 2
            }
        }
    }
    file:write(content)
    file:close()
end

local parse_file = function(build_dir)
    local dir = vim.fs.joinpath(build_dir, ".cmake", "api", "v1", "reply")
    if not vim.fn.isdirectory(dir) then return end
    local file = vim.fn.glob(vim.fs.joinpath(dir, "codemodel*.json"))
    if file == nil or #file == 0 then return end
    file = io.open(file, "r")
    local content = file:read("*a")
    local ok, json = pcall(vim.json.decode, content)
    if not ok then return end
    local build_targets = {}
    for _, row in ipairs(json.configurations[1].targets) do
        table.insert(build_targets, row.name)
    end
    return build_targets
end

return {
    setup = function(opts)
        local build_dir = vim.fs.joinpath(vim.fn.getcwd(), opts.build_dir or "build")

        local setup_command = string.format("cmake -S . -B %s ", build_dir)
        if opts.generator then
            setup_command = setup_command .. string.format("-G %s ", opts.generator)
        elseif type(opts.preset) == "string" then
            setup_command = setup_command .. string.format("--preset %s ", opts.preset)
        elseif type(opts.preset) == "function" then
            setup_command = setup_command .. string.format("--preset %s ", opts.preset())
        end

        utils.define_setup(setup_command,  function()
            create_file(build_dir)
        end, function ()
            utils.define_multi_build(nil, opts.post_build, {
                build_all = "cmake --build " .. build_dir,
                build_one = "cmake --build " .. build_dir .. " --target %s",
                build_targets = parse_file(build_dir)
            })
            if opts.post_setup ~= nil then opts.post_setup() end
        end)
    end
}
