---@type LazySpec[]
return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "nix" })
            end
        end,
    },
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            servers = {
                nil_ls = {
                    settings = {
                        ["nil"] = {
                            testSetting = 42,
                            formatting = { command = { "alejandra" } },
                        },
                    },
                },
            },
        },
    },
}
