local flake = '(builtins.getFlake "' .. vim.env.HOME .. '/dotfiles")'

---@type LazySpec[]
return {
  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        nixd = {
          settings = {
            ["nixd"] = {
              formatting = { command = { "nixfmt" } },
              nixpkgs = { expr = "import <nixpkgs> { }" },
              ["options"] = {
                ["nixos"] = {
                  expr = flake .. ".nixosConfigurations.ls-2100.options",
                },
                ["home-manager"] = {
                  expr = flake .. '.homeConfigurations."faust@ls-2100".options',
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
        -- for code actions and goto file (e.g. ./package/nixft)
        nil_ls = {
          on_attach = function(client, _)
            client.server_capabilities.semanticTokensProvider = nil
            client.server_capabilities.diagnosticProvider = nil
            client.server_capabilities.documentSymbolProvider = nil
            client.server_capabilities.documentFormattingProvider = nil
            client.server_capabilities.renameProvider = nil
            client.server_capabilities.completionProvider = nil
            client.server_capabilities.hoverProvider = nil
          end,
          settings = {
            ["nil"] = {
              formatting = { command = { "" } },
              nix = { flake = { nixpkgsInputName = "" } },
            },
          },
        },
      },
    },
  },
  -- formatter

  -- linter

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "nix" },
    },
  },

  -- test suite

  -- dap

  -- extra
}
