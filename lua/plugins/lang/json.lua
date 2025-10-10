---@type LazySpec[]
return {
  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        jsonls = {
          before_init = function(_, config)
            vim.list_extend(
              ---@diagnostic disable-next-line: undefined-field
              config.settings.json.schemas or {},
              require("schemastore").json.schemas()
            )
          end,
          settings = {
            json = {
              format = { enable = true },
              validate = { enable = true },
              schemas = {},
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
      ensure_installed = { "json", "jsonc" },
    },
  },

  -- test suite

  -- dap

  -- extra
  {
    "b0o/SchemaStore.nvim",
    version = false, -- last release is way too old
  },
}
