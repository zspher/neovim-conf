---@type LazySpec[]
return {

    -- lsp
    {
        "neovim/nvim-lspconfig",
        opts = {
            ---@type table<string, vim.lsp.Config>
            servers = {
                bashls = {},
            },
        },
    },
    -- formatter
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {

            formatters_by_ft = {
                bash = { "shfmt" },
            },
            formatters = {
                shfmt = {
                    prepend_args = { "-i", vim.o.tabstop, "-ci" },
                },
            },
        },
    },
    -- linter

    -- syntax highlight
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "bash" },
        },
    },

    -- test suite

    -- dap

    -- extra
}
