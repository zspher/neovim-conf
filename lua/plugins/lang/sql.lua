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
    {
        "kristijanhusak/vim-dadbod-ui",
        init = function()
            local Lazyvim = require "lazyvim.util"

            local data_path = vim.fn.stdpath "data"

            vim.g.db_ui_save_location = Lazyvim.root.get()
            vim.g.db_ui_show_database_icon = true
            vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
            vim.g.db_ui_use_nerd_fonts = true
            vim.g.db_ui_use_nvim_notify = true

            -- NOTE: The default behavior of auto-execution of queries on save is disabled
            -- this is useful when you have a big query that you don't want to run every time
            -- you save the file running those queries can crash neovim to run use the
            -- default keymap: <leader>S
            vim.g.db_ui_execute_on_save = false
        end,
    },
}
