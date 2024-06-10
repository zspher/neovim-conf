---@type LazySpec[]
return {
    {
        "folke/lazydev.nvim",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                "LazyVim",
                "lazy.nvim",
            },
        },
    },
}
