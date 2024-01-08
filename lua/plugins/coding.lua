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
        cmd = { "Harpoon" },
        keys = function(_, keys)
            local prefix = "<leader>h"
            local term_string = vim.fn.exists "$TMUX" == 1 and "tmux"
                or "terminal"
            return {
                {
                    prefix .. "a",
                    function() require("harpoon.mark").add_file() end,
                    desc = "Add file",
                },
                {
                    prefix .. "e",
                    function() require("harpoon.ui").toggle_quick_menu() end,
                    desc = "Toggle quick menu",
                },
                {
                    prefix .. "i",
                    function()
                        vim.ui.input(
                            { prompt = "Harpoon mark index: " },
                            function(input)
                                local num = tonumber(input)
                                if num then
                                    require("harpoon.ui").nav_file(num)
                                end
                            end
                        )
                    end,
                    desc = "Goto index of mark",
                },
                {
                    "<C-p>",
                    function() require("harpoon.ui").nav_prev() end,
                    desc = "Goto previous mark",
                },
                {
                    "<C-n>",
                    function() require("harpoon.ui").nav_next() end,
                    desc = "Goto next mark",
                },
                {
                    prefix .. "m",
                    "<cmd>Telescope harpoon marks<CR>",
                    desc = "Show marks in Telescope",
                },
                {
                    prefix .. "t",
                    function()
                        vim.ui.input(
                            { prompt = term_string .. " window number: " },
                            function(input)
                                local num = tonumber(input)
                                if num then
                                    require("harpoon." .. term_string).gotoTerminal(
                                        num
                                    )
                                end
                            end
                        )
                    end,
                    desc = "Go to " .. term_string .. " window",
                },
            }
        end,
    },
}
