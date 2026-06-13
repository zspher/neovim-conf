---@module 'snacks'
---@type LazySpec[]
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {},

      format_after_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return {
          async = true,
        }
      end,

      default_format_opts = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
    },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format {
            timeout_ms = 3000,
          }
        end,
        mode = { "n", "x" },
        desc = "Format",
      },
    },
  },
}
