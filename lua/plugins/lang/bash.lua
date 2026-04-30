---@type LazySpec[]
return {

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        -- supports explainshell, shellcheck and shfmt.
        bashls = {
          ---@type lspconfig.settings.bashls
          settings = {},
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
      ensure_installed = { "bash" },
    },
  },

  -- test suite

  -- dap

  -- extra
}
