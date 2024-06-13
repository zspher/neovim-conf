---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.lang.sql" },
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require "null-ls"
            opts.sources = vim.list_extend(opts.sources or {}, {
                nls.builtins.diagnostics.sqlfluff,
                nls.builtins.formatting.sqlfluff,
            })
        end,
    },
}
