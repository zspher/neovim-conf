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
            vim.list_extend(
              ---@diagnostic disable-next-line: undefined-field
              config.settings.yaml.schemas or {},
              require("schemastore").yaml().schemas()
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
