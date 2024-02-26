---@type LazySpec[]
return {
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            servers = {
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
    },
}
