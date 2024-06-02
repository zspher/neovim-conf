---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.lang.rust" },
    {
        "mrcjkb/rustaceanvim",
        optional = true,
        opts = {
            server = {
                on_attach = function(_, bufnr)
                    vim.keymap.set(
                        "n",
                        "<leader>ct",
                        function() vim.cmd.RustLsp "runnables" end,
                        { desc = "Rust run task", buffer = bufnr }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>cT",
                        function() vim.cmd.RustLsp { "runnables", bang = true } end,
                        { desc = "Rust restart task", buffer = bufnr }
                    )
                end,
            },
        },
    },
}
