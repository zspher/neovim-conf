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
            nil_ls = {
                settings = {
                    ["nil"] = {
                        testSetting = 42,
                        formatting = { command = { "alejandra" } },
                    },
                },
            },
        },
    },
}
