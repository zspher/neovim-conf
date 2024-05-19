---@type LazySpec[]
return {
    {
        "danymat/neogen",
        opts = {
            snippet_engine = "nvim",
        },
        dependencies = {
            {
                "folke/which-key.nvim",
                optional = true,
                opts = {
                    defaults = {
                        ["<leader>n"] = {
                            name = "+Neogen",
                            mode = "n",
                        },
                    },
                },
            },
        },
        keys = {
            {
                "<leader>nf",
                function() require("neogen").generate { type = "func" } end,
                desc = "function",
            },
            {
                "<leader>nc",
                function() require("neogen").generate { type = "class" } end,
                desc = "class",
            },
            {
                "<leader>nt",
                function() require("neogen").generate { type = "type" } end,
                desc = "type",
            },
            {
                "<leader>nF",
                function() require("neogen").generate { type = "file" } end,
                desc = "file",
            },
        },
    },
}
