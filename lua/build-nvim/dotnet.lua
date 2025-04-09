local utils = require("build-nvim.utils")
local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")

return {
    setup = function(opts)
        utils.define_setup("dotnet restore", nil, opts.post_setup)
        local solution = vim.fn.glob("*.slnx")
        if solution ~= nil and #solution > 0 then
            local file = io.open(solution, "r")
            local content = file:read("*a")
            local parser = xml2lua.parser(handler)
            parser:parse(content)
            local targets = {}
            for _, row in ipairs(handler.root.Solution.Project) do
                table.insert(targets, row._attr.Path)
            end
            return utils.define_multi_build(nil, nil, {
                build_targets = targets,
                build_all = "dotnet build " .. solution,
                build_one = "dotnet build %s",
            })
        end
    end
}