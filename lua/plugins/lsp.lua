return {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
        servers = {
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
