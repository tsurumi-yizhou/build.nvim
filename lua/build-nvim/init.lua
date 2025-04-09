return {
    setup = function(opts)
        vim.api.nvim_create_autocmd({"VimEnter"}, {
            callback = function()
                opts = opts or {}
                if #vim.fn.glob("pyproject.toml") > 0 then
                    require("build-nvim.poetry").setup(opts.poetry or {})
                end
                if #vim.fn.glob("astro.config.{ts,js,mts,mjs}") > 0 then
                    require("build-nvim.astro").setup(opts.astro or {})
                end
                if #vim.fn.glob("vite.config.{ts,js,mts,mjs}") > 0 then
                    require("build-nvim.vite").setup(opts.vite or {})
                end
                if #vim.fn.glob("CMakeLists.txt") > 0 then
                    require("build-nvim.cmake").setup(opts.cmake or {})
                end
                if #vim.fn.glob("*.{sln,slnx,csproj,fsproj}") > 0 then
                    require("build-nvim.dotnet").setup(opts.dotnet or {})
                end
            end
        })
    end
}
