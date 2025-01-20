---@type LazySpec[]
return {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
        codelens = {
            enabled = true,
        },
        servers = {
            lemminx = {},
            mesonlsp = {},
        },
    },
}
