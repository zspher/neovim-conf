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

      -- Check supported formatters and linters
      -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      opts.root_dir = opts.root_dir
        or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")

      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.formatting.prettierd.with {
          extra_args = { "--tab-width=" .. vim.o.tabstop, "--config-precedence=prefer-file" },
        },
      })
    end,
    dependencies = {
      "jay-babu/mason-null-ls.nvim",
    },
  },
}
