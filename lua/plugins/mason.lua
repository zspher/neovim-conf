return {
  {
    "williamboman/mason.nvim",
    opts = {
      PATH = "append",
    },
    optional = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    optional = true,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    optional = true,
  },
}
