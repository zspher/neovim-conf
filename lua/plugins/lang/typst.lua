---@type LazySpec[]
return {
    -- lsp
    {
        "neovim/nvim-lspconfig",
        opts = {
            ---@type table<string, vim.lsp.Config>
            servers = {
                tinymist = {},
            },
        },
    },
    -- formatter
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                typst = { "typstyle" },
            },
        },
    },
    -- linter

    -- syntax highlight
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "typst" },
        },
    },

    -- test suite

    -- dap

    -- extra
}
