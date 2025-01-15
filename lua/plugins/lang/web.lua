---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "css" } },
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                json = { "prettierd" },
                jsonc = { "prettierd" },
                yaml = { "prettierd" },
                css = { "prettierd" },
                html = { "prettierd" },
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        opts = {
            linters_by_ft = {},
        },
    },
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            servers = {
                jsonls = {},
                cssls = {},
                html = {},
                emmet_language_server = {},
                biome = {
                    single_file_support = true,
                },
            },
        },
    },
}
