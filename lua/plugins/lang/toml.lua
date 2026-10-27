---@type LazySpec[]
return {

  -- lsp
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        -- taplo = { },
        tombi = {
          ---@type lspconfig.settings.tombi
          settings = {
            tombi = {
              format = {
                rules = {
                  ["line-width"] = tonumber(vim.o.cc),
                },
              },
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
      ensure_installed = { "toml" },
    },
  },

  -- test suite

  -- dap

  -- extra
}
