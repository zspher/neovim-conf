---@type LazySpec[]
return {
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            servers = {
                zls = {},
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "zig" },
        },
    },
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = { "lawrence-laz/neotest-zig" },
        opts = {

            log_level = vim.log.levels.TRACE,
            adapters = {
                ["neotest-zig"] = {},
            },
        },
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                zig = { "zigfmt" },
            },
        },
    },
}
