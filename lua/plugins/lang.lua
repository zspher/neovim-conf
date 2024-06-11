---@type LazySpec[]
return {
    { import = "plugins.lang.bash" },
    { import = "plugins.lang.cs" },
    { import = "plugins.lang.nix" },
    { import = "lazyvim.plugins.extras.lang.tex" },
    { import = "plugins.lang.c-cpp" },
    { import = "plugins.lang.rust" },
    { import = "plugins.lang.python" },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function()
            -- register file type with language
            vim.treesitter.language.register("bash", "zsh")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "comment", "css" } },
    },
}
