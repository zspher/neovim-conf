---@type LazySpec[]
return {

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        texlab = {
          keys = {
            {
              "<Leader>K",
              "<plug>(vimtex-doc-package)",
              desc = "Vimtex Docs",
              silent = true,
            },
          },
        },
      },
    },
  },
  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    config = function()
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable "pplatex" == 1
          and "pplatex"
        or "latexlog"
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
    },
  },
  -- formatter

  -- linter

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- vimtex highlights clash with treesitter highlights
      ensure_installed = { "bibtex" },
      highlight = { disable = { "latex" } },
    },
  },

  -- test suite

  -- dap

  -- extra
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    ft = { "tex" },
    opts = {},
    dependencies = {
      "L3MON4D3/LuaSnip",
      "lervag/vimtex",
    },
  },
}
