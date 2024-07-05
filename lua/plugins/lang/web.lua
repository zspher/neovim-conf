---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.lang.typescript" },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "css" } },
    },
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require "null-ls"
            opts.sources = vim.list_extend(opts.sources or {}, {
                nls.builtins.formatting.prettierd.with {
                    disabled_filetypes = {
                        "javascript",
                        "javascriptreact",
                        "json",
                        "jsonc",
                        "typescript",
                        "typescriptreact",
                    },
                },
                nls.builtins.formatting.biome,
            })
        end,
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
