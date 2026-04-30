---@type LazySpec[]
return {

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        -- css
        cssmodules_ls = {},
        cssls = {
          ---@type lspconfig.settings.cssls
          settings = {
            css = { lint = { unknownAtRules = "ignore" } },
          },
        },
        tailwindcss = {
          ---@type lspconfig.settings.tailwindcss
          settings = {},
        },

        -- html
        html = {
          capabilities = {
            workspace = {
              didChangeWorkspaceFolders = { dynamicRegistration = true },
            },
          },
          ---@type lspconfig.settings.html
          settings = {},
        },
        superhtml = {
          on_attach = function(client, _)
            client.server_capabilities.documentFormattingProvider = nil
            client.server_capabilities.completionProvider = nil
            client.server_capabilities.renameProvider = nil
          end,
        },
        emmet_language_server = {
          init_options = {
            preferences = {
              ["output.inlineBreak"] = "2",
            },
          },
        },

        -- general
        biome = {},
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local ft = vim.lsp.config.emmet_language_server.filetypes or {}
      opts.servers.emmet_language_server.filetypes =
        vim.list_extend(ft, { "razor" })
    end,
  },

  -- formatter
  -- {
  --   "stevearc/conform.nvim",
  --   optional = true,
  --   opts = {
  --     formatters_by_ft = {},
  --   },
  -- },

  -- linter
  -- {
  --   "mfussenegger/nvim-lint",
  --   opts = {
  --     linters_by_ft = {
  --       -- html = { "htmlhint" },
  --     },
  --   },
  -- },

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "css", "scss", "html" },
    },
  },

  -- test suite

  -- dap

  -- extra
}
