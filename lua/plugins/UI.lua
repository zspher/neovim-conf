local function disable_cond()
    return function()
        if vim.bo.bt == "nofile" then return false end
        return true
    end
end

---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.ui.treesitter-context" },
    {
        "nvim-lualine/lualine.nvim",
        opts = function()
            local lualine_require = require "lualine_require"
            lualine_require.require = require

            local icons = require("lazyvim.config").icons

            vim.o.laststatus = vim.g.lualine_laststatus

            local opts = {
                options = {
                    section_separators = "",
                    component_separators = { left = "›", right = "|" },
                    disabled_filetypes = {
                        winbar = {
                            "dapui",
                            "dap-repl",
                            "qf",
                            "help",
                            "dashboard",
                            "alpha",
                            "starter",
                        },
                    },
                },
                sections = {
                    lualine_b = { "branch" },
                    lualine_c = {
                        LazyVim.lualine.root_dir(),
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                        },
                    },

                    lualine_x = {
                        {
                            function()
                                --- @diagnostic disable-next-line: undefined-field
                                return require("noice").api.status.command:get()
                            end,
                            cond = function()
                                return package.loaded["noice"]
                                    --- @diagnostic disable-next-line: undefined-field
                                    and require("noice").api.status.command:has()
                            end,
                            color = function() return LazyVim.ui.fg "Statement" end,
                        },
                        {
                            function()
                                return "  " .. require("dap").status()
                            end,
                            cond = function()
                                return package.loaded["dap"]
                                    and require("dap").status() ~= ""
                            end,
                            color = function() return LazyVim.ui.fg "Debug" end,
                        },
                        {
                            require("lazy.status").updates,
                            cond = require("lazy.status").has_updates,
                            color = function() return LazyVim.ui.fg "Special" end,
                        },
                    },
                    lualine_y = {
                        "progress",
                        {
                            "location",
                            separator = { left = " " },
                            padding = { left = 0, right = 1 },
                        },
                    },
                    lualine_z = {
                        function() return " " .. os.date "%R" end,
                    },
                },
                winbar = {
                    lualine_c = {
                        {
                            "filename",
                            file_status = true, -- Displays file status (readonly status, modified status)
                            newfile_status = false, -- Display new file status (new file means no write after created)
                            path = 3,
                            -- 0: Just the filename
                            -- 1: Relative path
                            -- 2: Absolute path
                            -- 3: Absolute path, with tilde as the home directory
                            -- 4: Filename and parent dir, with tilde as the home directory

                            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                            symbols = {
                                modified = "", -- Text to show when the file is modified.
                                readonly = "", -- Text to show when the file is non-modifiable or readonly.
                                unnamed = "", -- Text to show for unnamed buffers.
                                newfile = "", -- Text to show for newly created file before first write
                            },
                            cond = disable_cond(),
                        },
                    },
                },
            }

            local trouble = require "trouble"
            local symbols = trouble.statusline
                and trouble.statusline {
                    mode = "symbols",
                    groups = {},
                    title = false,
                    filter = { range = true },
                    format = "{kind_icon}{symbol.name:Normal}",
                    hl_group = "lualine_c_normal",
                }
            table.insert(opts.winbar.lualine_c, {
                symbols and symbols.get,
                cond = symbols and symbols.has,
            })
            return opts
        end,
    },
    {
        "akinsho/bufferline.nvim",
        opts = {
            options = {
                highlights = require(
                    "catppuccin.groups.integrations.bufferline"
                ).get(),
                indicator = { style = "none" },
                always_show_bufferline = true,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "Neo-tree",
                        highlight = "Directory",
                        text_align = "left",
                        separator = true,
                    },
                },
            },
        },
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
        lazy = true,
        dependencies = "nvim-treesitter/nvim-treesitter",
        event = "LazyFile",
        main = "rainbow-delimiters.setup",
    },
    {
        "nvchad/nvim-colorizer.lua",
        opts = {
            filetypes = {
                "*",
                css = { names = true, css = true },
            },
            user_default_options = {
                names = false,
            },
            buftypes = { "!nofile" },
        },
    },
}
