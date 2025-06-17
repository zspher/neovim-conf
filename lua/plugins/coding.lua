---@type LazySpec[]
return {
    { "echasnovski/mini.pairs", enabled = false },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
        keys = {
            {
                "<leader>up",
                function()
                    local Util = require "lazy.core.util"
                    require("nvim-autopairs").state.disabled =
                        not require("nvim-autopairs").state.disabled
                    if require("nvim-autopairs").state.disabled then
                        Util.warn("Disabled auto pairs", { title = "Option" })
                    else
                        Util.info("Enabled auto pairs", { title = "Option" })
                    end
                end,
                desc = "Toggle auto pairs",
            },
        },
    },
    { import = "lazyvim.plugins.extras.coding.neogen" },
    { import = "lazyvim.plugins.extras.coding.luasnip" },
    {
        "L3MON4D3/LuaSnip",
        opts = function(_, opts)
            require("luasnip.loaders.from_vscode").lazy_load {
                paths = "./snippets",
            }
            opts.enable_autosnippets = true
            opts.cut_selection_keys = "<C-j>"
        end,
        keys = {
            {
                "<C-j>",
                function() require("luasnip").jump(1) end,
                expr = true,
                silent = true,
                mode = { "s" },
            },
            {
                "<C-k>",
                function() require("luasnip").jump(-1) end,
                expr = true,
                silent = true,
                mode = { "i", "s" },
            },
        },
    },
    {
        "saghen/blink.cmp",
        optional = true,
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            cmdline = {
                enabled = true,
            },
            -- for debugging
            completion = {
                menu = {
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "source_name" },
                        },
                        components = {
                            source_name = {
                                text = function(ctx)
                                    return "[" .. ctx.source_name .. "]"
                                end,
                            },
                        },
                    },
                },
            },
            keymap = {
                preset = "default",
                ["<C-j>"] = { "snippet_forward", "fallback" },
                ["<C-k>"] = { "snippet_backward", "fallback" },
            },
        },
    },
    {
        "folke/ts-comments.nvim",
        opts = {
            lang = {
                typst = {
                    "// %s", -- default commentstring when no treesitter node matches
                    "/* %s */",
                },
            },
        },
    },

    { import = "lazyvim.plugins.extras.ai.supermaven" },
}
