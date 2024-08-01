---@type LazySpec[]
return {
    { import = "plugins.lang.bash" },
    { import = "plugins.lang.cs" },
    { import = "plugins.lang.nix" },
    { import = "plugins.lang.tex" },
    { import = "plugins.lang.c-cpp" },
    { import = "plugins.lang.rust" },
    { import = "plugins.lang.python" },
    { import = "plugins.lang.sql" },
    { import = "lazyvim.plugins.extras.lang.git" },
    { import = "plugins.lang.web" },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function()
            -- register file type with language
            vim.treesitter.language.register("bash", "zsh")
            vim.treesitter.language.register("qmljs", "qss")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "comment", "csv" } },
    },
}
