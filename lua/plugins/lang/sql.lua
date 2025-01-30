---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.lang.sql" },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = function(_, opts)
            opts.formatters.sqlfluff = {
                require_cwd = false,
            }
        end,
    },
}
