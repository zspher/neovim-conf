---@type LazySpec[]
return {

    -- lsp
    {
        "neovim/nvim-lspconfig",
        opts = {
            ---@type table<string, vim.lsp.Config>
            servers = {
                texlab = {
                    keys = {
                        {
                            "<Leader>K",
                            "<plug>(vimtex-doc-package)",
                            desc = "Vimtex Docs",
                            silent = true,
                        },
                    },
                },
            },
        },
    },
    {
        "lervag/vimtex",
        lazy = false, -- lazy-loading will disable inverse search
        config = function()
            vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
            vim.g.vimtex_quickfix_method = vim.fn.executable "pplatex" == 1
                    and "pplatex"
                or "latexlog"
        end,
        keys = {
            { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
        },
    },
    -- formatter

    -- linter

    -- syntax highlight
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "latex", "bibtex" },
        },
    },

    -- test suite

    -- dap

    -- extra
    {
        "iurimateus/luasnip-latex-snippets.nvim",
        ft = { "tex" },
        config = function()
            require("luasnip-latex-snippets").setup { use_treesitter = true }
            local ls = require "luasnip"
            ls.setup { enable_autosnippets = true }
        end,
        dependencies = {
            "L3MON4D3/LuaSnip",
        },
    },
}
