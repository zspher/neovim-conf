vim.api.nvim_create_autocmd("FileType", {
    desc = "set tabstop 2",
    pattern = { "markdown", "yaml", "css", "json", "jsonc" },
    callback = function()
        vim.o.tabstop = 2
        vim.o.shiftwidth = 2
    end,
})
