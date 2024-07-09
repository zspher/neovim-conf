---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.lang.typescript" },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "css" } },
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                javascript = { "biome" },
                javascriptreact = { "biome" },
                typescript = { "biome" },
                typescriptreact = { "biome" },

                json = { "prettierd" },
                jsonc = { "prettierd" },
                yaml = { "prettierd" },
                css = { "prettierd" },
                html = { "prettierd" },
                markdown = { "prettierd" },
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        opts = {
            linters_by_ft = {
                javascript = { "biomejs" },
                javascriptreact = { "biomejs" },
                typescript = { "biomejs" },
                typescriptreact = { "biomejs" },

                json = { "biomejs" },
                jsonc = { "biomejs" },
            },
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
                tailwindcss = {},
                emmet_language_server = {},
            },
        },
    },
}
