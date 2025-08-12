---@type LazySpec[]
return {
    {
        "neovim/nvim-lspconfig",
        optional = true,
        ---@class PluginLspOpts
        opts = {
            servers = {
                tinymist = {},
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = { ensure_installed = { "comment", "csv" } },
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                ["typst"] = { "typstyle" },
            },
        },
    },
}
