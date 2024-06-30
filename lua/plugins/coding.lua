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
        keys = {
            {
                "<C-j>",
                function()
                    return require("luasnip").choice_active()
                            and "<Plug>luasnip-next-choice"
                        or "<C-j>"
                end,
                expr = true,
                silent = true,
                mode = { "i", "s" },
            },
            {
                "<C-k>",
                function()
                    return require("luasnip").choice_active()
                            and "<Plug>luasnip-prev-choice"
                        or "<C-k>"
                end,
                expr = true,
                silent = true,
                mode = { "i", "s" },
            },
        },
    },
}
