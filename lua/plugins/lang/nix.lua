---@type LazySpec[]
local flake = '(builtins.getFlake "' .. vim.env.HOME .. '/dotfiles")'
return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "nix" },
        },
    },
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            servers = {
                nixd = {
                    settings = {
                        ["nixd"] = {
                            nixpkgs = { expr = "import <nixpkgs> { }" },
                            ["options"] = {
                                ["nixos"] = {
                                    expr = flake
                                        .. ".nixosConfigurations.ls-2100.options",
                                },
                                ["home-manager"] = {
                                    expr = flake
                                        .. '.homeConfigurations."faust@ls-2100".options',
                                },
                                ["flake-parts"] = {
                                    expr = flake .. ".debug.options",
                                },
                                ["flake-parts2"] = {
                                    expr = flake .. ".currentSystem.options",
                                },
                            },
                        },
                    },
                },
                nil_ls = {
                    settings = {
                        ["nil"] = {
                            testSetting = 42,
                            formatting = { command = { "nixfmt" } },
                        },
                    },
                },
            },
        },
    },
}
