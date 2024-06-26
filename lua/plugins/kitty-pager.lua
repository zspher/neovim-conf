if not vim.g.kitty_pager then return {} end

local enabled = {
    "catppuccin",
}

local Config = require "lazy.core.config"
Config.options.defaults.cond = function(plugin)
    return vim.tbl_contains(enabled, plugin.name)
end

return {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
        flavour = "mocha",
        transparent_background = false,
    },
}
