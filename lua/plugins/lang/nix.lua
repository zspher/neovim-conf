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
        opts = function()
            vim.lsp.enable { "nixd", "nil_ls" }
            vim.lsp.config("nixd", {
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
            })
            vim.lsp.config("nil_ls", {
                on_attach = function(client, _)
                    local capabilities = client.server_capabilities
                    capabilities.semanticTokensProvider = nil
                    capabilities.diagnosticProvider = nil
                    capabilities.documentSymbolProvider = nil
                    capabilities.documentFormattingProvider = nil
                    capabilities.renameProvider = nil
                    capabilities.referenceProvider = nil
                    capabilities.completionProvider = nil
                    capabilities.hoverProvider = nil
                end,
                settings = {
                    ["nil"] = {
                        formatting = { command = { "" } },
                        nix = { flake = { nixpkgsInputName = "" } },
                    },
                },
            })
        end,
    },
}
