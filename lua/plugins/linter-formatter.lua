---@type LazySpec[]
return {
    { "mfussenegger/nvim-lint", enabled = false },
    { "stevearc/conform.nvim", enabled = false },

    -- none-ls
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "jay-babu/mason-null-ls.nvim",
        },
        opts = function(_, opts)
            local nls = require "null-ls"
            vim.list_extend(opts.sources, {
                nls.builtins.code_actions.refactoring,
                nls.builtins.code_actions.gitsigns,

                nls.builtins.formatting.stylua,
                nls.builtins.formatting.prettierd,
                nls.builtins.formatting.biome,
            })
        end,
    },
}
