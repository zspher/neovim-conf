---@type LazySpec[]
return {
    { "mfussenegger/nvim-lint", enabled = false },
    { "stevearc/conform.nvim", enabled = false },

    -- none-ls
    { import = "lazyvim.plugins.extras.lsp.none-ls" },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "jay-babu/mason-null-ls.nvim",
        },
        opts = function(_, opts)
            local nls = require "null-ls"
            opts.root_dir = opts.root_dir
                or require("null-ls.utils").root_pattern(
                    ".null-ls-root",
                    ".neoconf.json",
                    "Makefile",
                    ".git"
                )
            opts.sources = {
                nls.builtins.code_actions.shellcheck,
                nls.builtins.code_actions.refactoring,
                nls.builtins.code_actions.gitsigns,

                nls.builtins.formatting.stylua,
                nls.builtins.formatting.shfmt.with {
                    extra_args = { "-i", vim.o.tabstop, "-ci" },
                },
                nls.builtins.formatting.prettierd,
                nls.builtins.formatting.biome,

                nls.builtins.formatting.csharpier,
            }
        end,
        keys = {
            { "<leader>cn", "<Cmd>NullLsInfo<cr>", desc = "Null-ls Info" },
        },
    },
}
