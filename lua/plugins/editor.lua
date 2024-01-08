---@type LazySpec[]
return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        opts = {
            enable_normal_mode_for_inputs = true,
            window = {
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
