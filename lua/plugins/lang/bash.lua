---@type LazySpec[]
return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "bash" },
        },
    },
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = function() vim.lsp.enable "bashls" end,
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters = {
                shfmt = {
                    prepend_args = { "-i", vim.o.tabstop, "-ci" },
                },
            },
        },
    },
}
