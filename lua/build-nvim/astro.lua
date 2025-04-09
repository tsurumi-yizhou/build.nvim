local utils = require("build-nvim.utils")

return {
    setup = function (opts)
        utils.define_setup("bun install", nil, opts.post_setup)
        utils.define_single_build("bun run build", nil, opts.post_build)
    end
}
