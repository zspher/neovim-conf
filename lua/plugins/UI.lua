local Util = require "lazyvim.util"
local icons = require("lazyvim.config").icons
local function disable_cond()
    return function()
        if vim.bo.bt == "nofile" then return false end
        return true
    end
end

---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.ui.treesitter-context" },
    { import = "lazyvim.plugins.extras.editor.aerial" },
    { -- overrides parts of aerial config
        "nvim-lualine/lualine.nvim",
        opts = {
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
                lualine_c = {
                    Util.lualine.root_dir(),
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
                    {
                        "aerial",
                        sep = " › ", -- separator between symbols
                        sep_icon = "", -- separator between icon and symbol

                        -- The number of symbols to render top-down. In order to render only 'N' last
                        -- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
                        -- be used in order to render only current symbol.
                        depth = 5,

                        -- When 'dense' mode is on, icons are not rendered near their symbols. Only
                        -- a single icon that represents the kind of current symbol is rendered at
                        -- the beginning of status line.
                        dense = false,

                        -- The separator to be used to separate symbols in dense mode.
                        dense_sep = ".",

                        -- Color the symbol icons.
                        colored = true,
                    },
                },
            },
        },
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
        "lukas-reineke/indent-blankline.nvim",
        branch = "current-indent",
        opts = {
            current_indent = {
                enabled = true,
                show_start = false,
                show_end = false,
                highlight = "RainbowDelimiterBlue",
            },
        },
        dependencies = {
            "HiPhish/rainbow-delimiters.nvim",
            lazy = true,
            dependencies = "nvim-treesitter/nvim-treesitter",
            event = "LazyFile",
            main = "rainbow-delimiters.setup",
        },
    },
    {
        "nvchad/nvim-colorizer.lua",
        opts = {
            filetypes = {
                "*",
                css = { names = true },
            },
            user_default_options = {
                names = false,
            },
            buftypes = { "!nofile" },
        },
    },
}
