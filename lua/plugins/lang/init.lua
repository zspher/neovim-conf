vim.treesitter.language.register("bash", "zsh")
vim.treesitter.language.register("qmljs", "qss")

vim.filetype.add {
    extension = {
        axaml = "xml",
        obt = "qss",
        ovt = "qss",

        mdx = "markdown.mdx",
    },
    pattern = {
        [".*/hypr/.+%.conf"] = "hyprlang",
    },
}

---@type LazySpec[]
return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "comment", "csv" } },
    },
}
