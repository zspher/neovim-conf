---@type LazySpec[]
return {

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        lemminx = {
          filetypes = { "xml", "xsd", "xsl", "xslt", "svg", "xhtml" },
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
      ensure_installed = { "xml" },
    },
  },

  -- test suite

  -- dap

  -- extra
}
