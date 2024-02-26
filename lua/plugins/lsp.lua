---@type LazySpec[]
return {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
        servers = {
            lemminx = {},
            clangd = {
                capabilities = {
                    offsetEncoding = "utf-8",
                },
            },
        },
    },
}
