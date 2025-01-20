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
        opts = { enable_autosnippets = true },
        config = function(_)
            require("luasnip.loaders.from_vscode").lazy_load {
                paths = "./snippets",
            }
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
        opts = {
            keymap = {
                preset = "default",
                ["<C-j>"] = { "snippet_forward", "fallback" },
                ["<C-k>"] = { "snippet_backward", "fallback" },
            },
        },
    },
}
