---@type LazySpec[]
return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        ---@module 'catppuccin'
        ---@type CatppuccinOptions
        opts = {
            float = {
                transparent = true,
                solid = false,
            },
            flavour = "mocha",
            transparent_background = true,
            integrations = {
                fzf = true,
                harpoon = true,
                lsp_trouble = true,
                mason = true,
                neotest = true,
                neotree = true,
                noice = true,
                notify = true,
                which_key = true,
                treesitter = true,
                treesitter_context = true,
                snacks = true,
            },
            custom_highlights = function(c)
                return {
                    LineNrAbove = { fg = c.subtext0 },
                    LineNrBelow = { fg = c.subtext0 },
                    CursorLineNr = { fg = c.peach, style = { "bold" } },
                    LineNr = { fg = c.peach, style = { "bold" } },
                    SnacksIndent1 = { fg = c.blue },
                }
            end,
        },
    },
    {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
            if (vim.g.colors_name or ""):find "catppuccin" then
                opts.highlights = require(
                    "catppuccin.groups.integrations.bufferline"
                ).get_theme()
            end
        end,
    },
}
