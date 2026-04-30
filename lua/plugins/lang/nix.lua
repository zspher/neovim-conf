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
          ---@type lspconfig.settings.nixd
          settings = {
            nixd = {
              formatting = { command = { "nixfmt" } },
              nixpkgs = { expr = "import <nixpkgs> { }" },
              ["options"] = {
                ["nixos"] = {
                  expr = string.format(
                    '%s.nixosConfigurations."%s".options',
                    flake,
                    vim.fn.hostname()
                  ),
                },
                ["home-manager"] = {
                  expr = string.format(
                    '%s.homeConfigurations."%s@%s".options',
                    flake,
                    vim.env.USER,
                    vim.fn.hostname()
                  ),
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
      },
    },
  },

  -- formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        nix = { "nixfmt", lsp_format = "prefer" },
      },
    },
  },

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
