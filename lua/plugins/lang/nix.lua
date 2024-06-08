---@type LazySpec[]
return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "nix" },
        },
    },
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
