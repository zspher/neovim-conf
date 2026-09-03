---@type LazySpec[]
return {

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        dartls = {
          ---@type lspconfig.settings.dartls
          settings = {},
        },
      },
    },
  },
  -- formatter
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        dart = { "dart_format" },
      },
    },
  },

  -- linter

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "dart" },
    },
  },

  -- test suite
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "sidlatau/neotest-dart",
    },
    opts = {
      adapters = {
        ["neotest-dart"] = {},
      },
    },
  },

  -- dap
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require "dap"
      dap.configurations.dart = {
        {
          type = "dart",
          name = "dart: launch",
          request = "launch",
          program = function()
            local file = require("dap.utils").pick_file {
              filter = vim.uv.cwd() .. "/bin/.*%.dart",
              executables = false,
            }
            return file
          end,
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },

  -- extra
}
