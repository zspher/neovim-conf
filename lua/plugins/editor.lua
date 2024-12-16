local oil_detail = false
---@type LazySpec[]
return {
    { "wakatime/vim-wakatime", event = "LazyFile" },
    { import = "lazyvim.plugins.extras.editor.refactoring" },
    {
        "folke/which-key.nvim",
        optional = true,
        opts = { preset = "modern" },
    },
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
    { "nvim-neo-tree/neo-tree.nvim", enabled = false },
    {
        "refractalize/oil-git-status.nvim",
        config = true,
        event = "VeryLazy",
        dependencies = {
            "stevearc/oil.nvim",
        },
    },
    {
        "stevearc/oil.nvim",
        cmd = "Oil",
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            skip_confirm_for_simple_edits = true,
            delete_to_trash = true,
            keymaps = {
                ["q"] = "actions.close",
                ["<C-h>"] = false,
                ["<A-h>"] = "actions.select_split",
                ["gd"] = {
                    desc = "Toggle file detail view",
                    callback = function()
                        oil_detail = not oil_detail
                        if oil_detail then
                            require("oil").set_columns {
                                "permissions",
                                { "size", highlight = "Comment" },
                                { "mtime", highlight = "Conceal" },
                                "icon",
                            }
                        else
                            require("oil").set_columns { "icon" }
                        end
                    end,
                },
            },
            view_options = {
                show_hidden = true,
                highlight_filename = function(entry, _, _, _)
                    local state = vim.uv.fs_stat(entry.name)
                    if state and state.type == "file" then
                        local perms =
                            string.format("%o", bit.band(state.mode, 511))
                        local l = { "1", "3", "5", "7" }
                        for _, v in ipairs(l) do
                            if perms:match(v) then return "Error" end
                        end
                    end
                    return nil
                end,
            },
            win_options = {
                signcolumn = "yes",
            },
        },
        keys = {
            {
                "<leader>e",
                function()
                    if vim.bo.ft == "oil" then
                        require("oil").close()
                    else
                        require("oil").open(nil)
                    end
                end,
                desc = "Explorer (Current Dir)",
            },
            {
                "<leader>E",
                function()
                    if vim.bo.ft == "oil" then
                        require("oil").close()
                    else
                        require("oil").open(require("lazyvim.util").root())
                    end
                end,
                desc = "Explorer (Root Dir)",
            },
        },
    },
    {
        "ibhagwan/fzf-lua",
        opts = {
            previewers = {
                codeaction_native = {
                    pager = [[delta --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"]],
                },
            },
            winopts = {
                preview = { wrap = "wrap" },
            },
            grep = {
                rg_glob = true,
            },
        },
    },
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = {
            {
                "<leader>fu",
                "<cmd>UndotreeToggle<CR>",
                desc = "Find undotree",
            },
        },
    },
}
