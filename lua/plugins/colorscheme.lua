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
                nvimtree = false,

                aerial = true,
                harpoon = true,
                leap = true,
                lsp_trouble = true,
                mason = true,
                neotest = true,
                neotree = true,
                noice = true,
                notify = true,
                symbols_outline = true,
                telescope = { enabled = true },
                which_key = true,
            },
            custom_highlights = function(colors)
                return {
                    LineNrAbove = { fg = colors.subtext0 },
                    LineNrBelow = { fg = colors.subtext0 },
                    LineNr = { fg = colors.peach, style = { "bold" } },
                    CursorLineNr = { fg = colors.peach, style = { "bold" } },
                }
            end,
        },
    },
    {
        "rcarriga/nvim-notify",
        opts = {
            background_colour = "#000000",
            timeout = 2000,
        },
    },
}
