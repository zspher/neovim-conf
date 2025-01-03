---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.lang.git" },
    { import = "plugins.lang.bash" },
    { import = "plugins.lang.c-cpp" },
    { import = "plugins.lang.cs" },
    { import = "plugins.lang.nix" },
    { import = "plugins.lang.python" },
    { import = "plugins.lang.rust" },
    { import = "plugins.lang.sql" },
    { import = "plugins.lang.tex" },
    { import = "plugins.lang.web" },
    { import = "plugins.lang.zig" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
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
