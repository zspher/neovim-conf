---@type LazySpec[]
return {

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        yamlls = {
          before_init = function(_, config)
            ---@diagnostic disable-next-line:  inject-field
            config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            yaml = { schemaStore = { enable = false, url = "" } },
            schemas = {},
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
      ensure_installed = { "yaml" },
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
