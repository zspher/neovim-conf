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
                "filetype",
                {
                    "diagnostics",
                    symbols = {
                        error = icons.diagnostics.Error,
                        warn = icons.diagnostics.Warn,
                        info = icons.diagnostics.Info,
                        hint = icons.diagnostics.Hint,
                    },
                },
                {
                    function()
                        local data = vim.fn.systemlist(
                            "magick identify " .. vim.api.nvim_buf_get_name(0)
                        )[1]
                        local width, height = data:match "%s(%d+)x(%d+)%s"

                        return "h: " .. height .. " w: " .. width
                    end,
                    cond = function() return vim.bo.ft == "image" end,
                },
            }
            opts.options = {
                section_separators = "",
                component_separators = { left = "", right = "|" },

                disabled_filetypes = {
                    winbar = vim.list_extend(
                        opts.options.disabled_filetypes.statusline,
                        { "qf", "help", "dapui", "dap-repl" }
                    ),
                },
            }

            local trouble = require "trouble"
            local symbols = trouble.statusline
                and trouble.statusline {
                    mode = "symbols",
                    groups = {},
                    title = false,
                    filter = { range = true },
                    format = "{kind_icon}{symbol.name:Normal} ›",
                    hl_group = "lualine_c_normal",
                }
            local wb = {
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
                        color = "lualine_c_normal",
                        cond = disable_cond(),
                    },
                    {
                        symbols and symbols.get,
                        cond = symbols and symbols.has,
                        separator = { left = "›" },
                        fmt = function(str) -- return string except for last "›"
                            return str:gsub("(.*)›([^›]*)$", "%1")
                        end,
                    },
                },
            }

            opts.winbar = wb
            opts.inactive_winbar = wb
        end,
    },
    {
        "akinsho/bufferline.nvim",
        opts = {
            options = {
                indicator = { style = "none" },
                always_show_bufferline = true,
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
        event = "LazyFile",
        opts = {
            filetypes = {
                "*",
                qss = { css = true },
                css = { css = true },
            },
            user_default_options = {
                names = false,
                always_update = true,
                tailwind = "lsp",
            },
            buftypes = { "!nofile" },
        },
    },
    {
        "folke/snacks.nvim",
        ---@module 'snacks'
        ---@type snacks.Config
        opts = {
            ---@type table<string, snacks.win.Config>
            styles = {},
            indent = {
                scope = {
                    hl = "SnacksIndent1",
                },
            },
        },
    },
    {
        "3rd/image.nvim",
        optional = true,
        ---@module 'image'
        ---@type Options
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            integrations = {
                markdown = {
                    resolve_image_path = function(
                        document_path,
                        image_path,
                        fallback
                    )
                        local root = LazyVim.root.get()

                        if
                            vim.uv.fs_stat(
                                document_path:match "(.*/)" .. "/" .. image_path
                            )
                        then
                            return fallback(document_path, image_path)
                        end

                        if
                            vim.uv.fs_stat(root .. "/assets")
                            and vim.uv.fs_stat(root .. "/.obsidian")
                        then
                            vim.print(
                                "d: " .. document_path .. " i: " .. image_path
                            )
                            return root .. "/assets/" .. image_path
                        end

                        return fallback(document_path, image_path)
                        -- document_path is the path to the file that contains the image
                        -- image_path is the potentially relative path to the image. for
                        -- markdown it's `![](this text)`

                        -- you can call the fallback function to get the default behavior
                    end,
                },
            },
        },
    },
}
