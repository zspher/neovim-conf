---@type LazySpec[]
return {
    { "wakatime/vim-wakatime", event = "LazyFile" },
    { import = "lazyvim.plugins.extras.editor.refactoring" },
    {
        "ThePrimeagen/refactoring.nvim",
        keys = {
            {
                "<leader>rI",
                function() require("refactoring").refactor "Inline Function" end,
                desc = "Inline Function",
            },
        },
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            {
                "folke/which-key.nvim",
                optional = true,
                opts = {
                    defaults = {
                        ["<leader>h"] = { name = "+harpoon", mode = "n" },
                    },
                },
            },
        },
        opts = {
            settings = {
                save_on_toggle = true,
            },
        },
        config = function(_, opts)
            local harpoon = require "harpoon"
            local extensions = require "harpoon.extensions"
            harpoon:setup(opts)
            harpoon:extend(extensions.builtins.navigate_with_number())
        end,
        keys = function()
            local harpoon = require "harpoon"
            return {
                {
                    "<leader>ha",
                    function() harpoon:list():add() end,
                    desc = "Add file",
                },
                {
                    "<leader>he",
                    function()
                        harpoon.ui:toggle_quick_menu(harpoon:list(), {
                            border = "rounded",
                            title_pos = "center",
                            title = " Harpoon ",
                            ui_max_width = 100,
                        })
                    end,
                    desc = "Toggle quick menu",
                },
                {
                    "<C-p>",
                    function() harpoon:list():prev { ui_nav_wrap = true } end,
                    desc = "Goto previous mark",
                },
                {
                    "<C-n>",
                    function() harpoon:list():next { ui_nav_wrap = true } end,
                    desc = "Goto next mark",
                },
            }
        end,
    },
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
}
