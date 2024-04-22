---@type LazySpec[]
return {
    { "echasnovski/mini.surround", enabled = false },
    { "wakatime/vim-wakatime", event = "LazyFile" },
    {
        "tpope/vim-fugitive",
        cmd = {
            "G",
            "Git",
            "Gdiffsplit",
            "Gvdiffsplit",
            "Gedit",
            "Gsplit",
            "Gread",
            "Gwrite",
            "Ggrep",
            "Glgrep",
            "Gmove",
            "Gdelete",
            "Gremove",
            "Gbrowse",
        },
    },
    {
        "ThePrimeagen/refactoring.nvim",
        --- @diagnostic disable-next-line: assign-type-mismatch
        keys = function()
            local prefix = "<leader>c"
            return {
                {
                    prefix .. "e",
                    mode = { "v" },
                    function()
                        require("refactoring").refactor "Extract Function"
                    end,
                    desc = "Extract Function",
                },
                {
                    prefix .. "E",
                    mode = { "v" },
                    function()
                        require("refactoring").refactor "Extract Function To File"
                    end,
                    desc = "Extract Function to File",
                },
                {
                    prefix .. "v",
                    mode = { "v" },
                    function()
                        require("refactoring").refactor "Extract Variable"
                    end,
                    desc = "Extract Variable",
                },
                {
                    prefix .. "I",
                    function()
                        require("refactoring").refactor "Inline Function"
                    end,
                    desc = "Inline Function",
                },
                {
                    prefix .. "i",
                    mode = { "v", "n" },
                    function()
                        require("refactoring").refactor "Inline Variable"
                    end,
                    desc = "Inline Variable",
                },
                {
                    prefix .. "b",
                    function() require("refactoring").refactor "Extract Block" end,
                    desc = "Extract Block",
                },
                {
                    prefix .. "B",
                    function()
                        require("refactoring").refactor "Extract Block To File"
                    end,
                    desc = "Extract Block to File",
                },
            }
        end,
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
        --- @diagnostic disable-next-line: assign-type-mismatch
        keys = function()
            local prefix = "<leader>h"
            local harpoon = require "harpoon"
            return {
                {
                    prefix .. "a",
                    function() harpoon:list():add() end,
                    desc = "Add file",
                },
                {
                    prefix .. "e",
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
}
