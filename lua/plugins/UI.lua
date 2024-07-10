local function disable_cond()
    return function() return not (vim.bo.bt == "nofile") end
    -- for nofile buffers like neo-tree
end

---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.ui.treesitter-context" },
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            local icons = LazyVim.config.icons
            opts.sections.lualine_c = {
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
            }
            opts.options = {
                section_separators = "",
                component_separators = { left = "›", right = "|" },

                disabled_filetypes = {
                    winbar = vim.list_extend(
                        opts.options.disabled_filetypes.statusline,
                        { "qf", "help", "dapui", "dap-repl" }
                    ),
                },
            }
            opts.winbar = {
                lualine_c = {
                    {
                        "filename",
                        path = 3,
                        symbols = {
                            modified = "",
                            readonly = "",
                            unnamed = "",
                            newfile = "",
                        },
                        cond = disable_cond(),
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
                always_update = true,
                tailwind = "lsp",
            },
            buftypes = { "!nofile" },
        },
    },
}
