---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.lang.tex" },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "latex" } },
    },
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
