return {
  { import = "lazyvim.plugins.extras.lsp.none-ls" },
  {
    "mfussenegger/nvim-lint",
    ops = {
      linters_by_ft = {
        fish = { "fish" },
        bash = { "shellcheck" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        vue = { "prettierd" },
        css = { "prettierd" },
        scss = { "prettierd" },
        less = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        ["markdown.mdx"] = { "prettierd" },
        graphql = { "prettierd" },
        handlebars = { "prettierd" },

        bash = { "shfmt" },
        cs = { "csharpier" },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", vim.o.tabstop, "-ci" },
        },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",

    opts = function(_, opts)
      local nls = require "null-ls"
      opts.root_dir = opts.root_dir
        or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
      opts.sources = {
        nls.builtins.code_actions.shellcheck,
        nls.builtins.code_actions.refactoring,
        nls.builtins.code_actions.gitsigns,
      }
    end,
  },
}
