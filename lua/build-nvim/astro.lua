local utils = require("build-nvim.utils")

return {
    condition = function()
        return #vim.fn.glob("astro.config.{ts,js,mts,mjs}") > 0
    end,
    setup = function(opts)
        local config = utils.read_config {
            tsserver = "~/.bun/install/global/node_modules/typescript/lib",
            runtime = "~/.bun/bin/bun",
            command = "bun run build"
        }

        vim.api.nvim_create_user_command("Build", function ()
            utils.popup(config.command, opts.post_build)
        end, { nargs = 0 })

        if opts.post_setup then
            opts.post_setup(config.tsserver, config.runtime)
        end
    end
}
