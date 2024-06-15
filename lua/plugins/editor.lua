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
                { "<leader>h", "", desc = "+harpoon", mode = { "n" } },
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
    {
        "nvim-neo-tree/neo-tree.nvim",
        opts = {
            event_handlers = {

                {
                    event = "neo_tree_buffer_enter",
                    handler = function()
                        vim.opt_local.relativenumber = true
                        vim.opt_local.number = true
                    end,
                },
                {
                    event = "neo_tree_popup_input_ready",
                    ---@param args { bufnr: integer, winid: integer }
                    handler = function(args)
                        vim.cmd "stopinsert"
                        vim.keymap.set(
                            "i",
                            "<esc>",
                            vim.cmd.stopinsert,
                            { noremap = true, buffer = args.bufnr }
                        )
                    end,
                },
            },
            window = {
                position = "current",
                mappings = {
                    ["a"] = {
                        "add",
                        config = {
                            show_path = "absolute",
                        },
                    },
                    ["m"] = {
                        "move",
                        config = {
                            show_path = "absolute",
                        },
                    },
                    ["c"] = {
                        "copy",
                        config = {
                            show_path = "absolute",
                        },
                    },
                },
            },
            filesystem = {
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    never_show = { ".git" },
                },
            },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        opts = {
            pickers = {
                find_files = {
                    find_command = {
                        "fd",
                        "--type",
                        "f",
                        "--color",
                        "never",
                        "--hidden",
                        "-E",
                        ".git",
                    },
                },
                live_grep = {
                    glob_pattern = { "!.git/" },
                    additional_args = { "--hidden" },
                },
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        },
    },
    {
        "folke/which-key.nvim",
        opts = {
            defaults = {
                s = "which_key_ignore",
                ["<S-s>"] = "which_key_ignore",
            },
        },
    },
}
