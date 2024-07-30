---@type LazySpec[]
return {
    { "folke/tokyonight.nvim", enabled = false },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin",
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        opts = {
            flavour = "mocha",
            transparent_background = true,
            integrations = {
                alpha = false,
                neogit = false,
                nvimtree = false,
                telescope = { enabled = false },

                harpoon = true,
                lsp_trouble = true,
                mason = true,
                neotest = true,
                neotree = true,
                noice = true,
                notify = true,
                which_key = true,
            },
            custom_highlights = function(c)
                return {
                    LineNrAbove = { fg = c.subtext0 },
                    LineNrBelow = { fg = c.subtext0 },
                    CursorLineNr = { fg = c.peach, style = { "bold" } },

                    -- fzf colos
                    FzfLuaBorder = { link = "FloatBorder" },
                    FzfLuaTitle = { link = "FloatBorder" },
                    FzfLuaHeaderBind = { fg = c.yellow },
                    FzfLuaBufNr = { fg = c.yellow },
                    FzfLuaTabMarker = { fg = c.yellow },
                    FzfLuaHeaderText = { fg = c.peach },
                    FzfLuaBufFlagCur = { fg = c.peach },
                    FzfLuaLiveSym = { fg = c.peach },
                    FzfLuaPathColNr = { fg = c.blue },
                    FzfLuaBufFlagAlt = { fg = c.blue },
                    FzfLuaTabTitle = { fg = c.sky },
                    FzfLuaPathLineNr = { fg = c.green },
                    FzfLuaBufName = { fg = c.mauve },
                }
            end,
        },
    },
}
