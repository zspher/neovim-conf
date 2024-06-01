---@type LazySpec[]
return {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
        servers = {
            lemminx = {},
            mesonlsp = {},
            jsonls = {},
            cssls = {},
            html = {},
        },
    },
}
