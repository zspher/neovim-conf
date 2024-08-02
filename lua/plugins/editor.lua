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
        keys = {
            {
                "<leader>fe",
                function()
                    require("neo-tree.command").execute {
                        toggle = true,
                        dir = LazyVim.root(),
                        reveal = true,
                    }
                end,
                desc = "Explorer NeoTree (Root Dir)",
            },
        },
        opts = {
            event_handlers = {
                {
                    event = "neo_tree_buffer_enter",
                    handler = function()
                        vim.opt_local.relativenumber = true
                        vim.opt_local.number = true
                        vim.opt_local.cc = ""

                        local ns_id =
                            vim.api.nvim_create_namespace "neo-tree.nvim"
                        vim.api.nvim_set_hl(
                            ns_id,
                            "LineNr",
                            vim.api.nvim_get_hl(0, { name = "CursorLineNr" }) --[[@as vim.api.keyset.highlight]]
                        )
                        vim.api.nvim_win_set_hl_ns(0, ns_id)
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
        "ibhagwan/fzf-lua",
        opts = {
            previewers = {},
            winopts = {
                preview = { wrap = "wrap" },
            },
        },
    },
}
