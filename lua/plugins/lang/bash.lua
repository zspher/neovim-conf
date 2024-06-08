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
        opts = {
            servers = {
                bashls = {},
            },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        optional = true,
        opts = function(_, opts)
            vim.list_extend(opts.sources, {
                require("null-ls").builtins.formatting.shfmt.with {
                    extra_args = { "-i", vim.o.tabstop, "-ci" },
                },
            })
        end,
    },
}
