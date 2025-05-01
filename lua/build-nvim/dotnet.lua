local utils = require("build-nvim.utils")
local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")

function string:endswith(suffix)
    return self:sub(- #suffix) == suffix
end

function parse_xml(node)
    local targets = {}

    if node.Project then
        if node.Project._attr then
            targets[#targets + 1] = {
                name = node.Project._attr.Path,
                command = "dotnet build " .. node.Project._attr.Path
            }
        else
            for _, project in ipairs(node.Project) do
                targets[#targets + 1] = {
                    name = project._attr.Path,
                    command = "dotnet build " .. project._attr.Path
                }
            end
        end
    end

    if node.Folder then
        for _, target in ipairs(parse_xml(node.Folder)) do
            targets[#targets + 1] = target
        end
    end

    return targets
end

return {
    condition = function()
        if #vim.fn.glob("*.{slnx,vcproj,vcxproj,csproj,fsproj}") > 0 then
            return true
        end
        return false
    end,
    setup = function(opts)
        local solution = vim.fn.glob("*.slnx")
        if #solution > 0 then
            local file = io.open(solution, "r")
            local content = file:read("*a")
            file:close()

            local parser = xml2lua.parser(handler)
            parser:parse(content)
            local targets = parse_xml(handler.root.Solution)
            utils.register(targets, opts.post_build)

            local languages = {}
            for _, target in ipairs(targets) do
                if target.name:endswith("vcproj") then
                    languages[#languages + 1] = "cpp"
                elseif target.name:endswith("vcxproj") then
                    languages[#languages + 1] = "cpp"
                elseif target.name:endswith("csproj") then
                    languages[#languages + 1] = "csharp"
                elseif target.name:endswith("fsproj") then
                    languages[#languages + 1] = "fsharp"
                end
            end

            if opts.post_setup then
                opts.post_setup(languages)
            end
        end
    end
}
