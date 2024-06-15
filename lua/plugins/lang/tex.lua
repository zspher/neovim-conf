---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.lang.tex" },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "latex" } },
    },
    {
        "iurimateus/luasnip-latex-snippets.nvim",
        opts = { use_treesitter = true },
    },
}
