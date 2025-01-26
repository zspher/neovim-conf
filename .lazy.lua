---@type LazySpec[]
return {
    {
        "folke/lazydev.nvim",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                "LazyVim",
                "lazy.nvim",
            },
        },
    },
}
