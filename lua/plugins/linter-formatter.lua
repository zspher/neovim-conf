return {
  "nvimtools/none-ls.nvim",
  opts = function(_, config)
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      null_ls.builtins.formatting.shfmt.with { extra_args = { "-i", vim.o.tabstop, "-ci" } },
      null_ls.builtins.formatting.prettierd.with {
        extra_args = { "--tab-width=" .. vim.o.tabstop, "--config-precedence=prefer-file" },
      },
    }
  end,
}
