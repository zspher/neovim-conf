---@type LazySpec[]
return {
    { import = "plugins.lang.bash" },
    { import = "plugins.lang.cs" },
    { import = "plugins.lang.nix" },
    { import = "lazyvim.plugins.extras.lang.tex" },
    { import = "plugins.lang.c-cpp" },
    { import = "plugins.lang.rust" },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            -- register file type with language
            vim.treesitter.language.register("bash", "zsh")
            -- add more things to the ensure_installed table protecting against community packs modifying it
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "comment" })
                --
            end
        end,
    },
    { import = "lazyvim.plugins.extras.lang.python" },
    {

        "nvim-neotest/neotest",
        opts = function(_, opts)
            opts.adapters = {
                ["neotest-python"] = {
                    dap = { justMyCode = false },
                    pytest_discover_instances = true,
                },
            }
        end,
    },
}
