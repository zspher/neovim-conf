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
        ---@module 'catppuccin'
        ---@type CatppuccinOptions
        opts = {
            flavour = "mocha",
            transparent_background = true,
            integrations = {
                alpha = false,
                neogit = false,
                nvimtree = false,
                telescope = { enabled = false },

                fzf = true,
                harpoon = true,
                lsp_trouble = true,
                mason = true,
                neotest = true,
                neotree = true,
                noice = true,
                notify = true,
                which_key = true,
                snacks = true,
            },
            custom_highlights = function(c)
                return {
                    LineNrAbove = { fg = c.subtext0 },
                    LineNrBelow = { fg = c.subtext0 },
                    CursorLineNr = { fg = c.peach, style = { "bold" } },
                    SnacksIndent1 = { fg = c.blue },
                }
            end,
        },
    },
}
