---@type LazySpec[]
return {
  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                  { path = "lazy.nvim", words = { "LazyVim" } },
                },
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "All",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
    },
  },
  -- formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
  -- linter

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "lua", "luadoc" },
    },
  },

  -- test suite

  -- dap

  -- extra
}
