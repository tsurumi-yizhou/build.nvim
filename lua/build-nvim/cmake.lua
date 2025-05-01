local utils = require("build-nvim.utils")
local dir_path = vim.fs.joinpath(vim.fn.getcwd(), "build", ".cmake", "api", "v1")
local query_path = vim.fs.joinpath(dir_path, "query", "codemodel-v2")
local answer_path = vim.fs.joinpath(dir_path, "reply", "codemodel*.json")
local setup_dir = vim.fs.joinpath(vim.fn.getcwd(), ".nvim")
local setup_path = vim.fs.joinpath(setup_dir, "setup.json")

function write_query()
    vim.fn.mkdir(vim.fs.joinpath(dir_path, "query"), "p")
    local file = io.open(query_path, "w")
    file:close()
end

function parse_reply()
    local filename = vim.fn.glob(answer_path)
    local file = io.open(filename, "r")
    local reply = vim.json.decode(file:read("*a"))
    file:close()
    local targets = {}
    for _, configuration in ipairs(reply.configurations) do
        for _, target in ipairs(configuration.targets) do
            targets[#targets + 1] = {
                name = target.name,
                command = "cmake --build build --target " .. target.name
            }
        end
    end
    return targets
end

return {
    condition = function()
        return #vim.fn.glob("CMakeLists.txt") > 0
    end,
    setup = function(opts)
        write_query()

        local config = utils.read_config {
            build_dir = "build",
            command = "cmake -S . -B build -G Ninja"
        }

        vim.fn.system(config.command)
        utils.register(parse_reply(), opts.post_build)
        if opts.post_setup then
            opts.post_setup(config.build_dir)
        end
    end
}
