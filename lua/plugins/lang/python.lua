---@type LazySpec[]
return {

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        -- might want to look at https://github.com/astral-sh/ty
        -- pyright = {
        --   settings = {
        --     python = { analysis = { typeCheckingMode = "strict" } },
        --   },
        -- },
        ty = {},
        ruff = {
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = {
            settings = {
              logLevel = "error",
            },
          },
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                }
              end,
              desc = "Organize Imports",
            },
          },
          on_attach = function(client, _)
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end,
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
        bash = { "shfmt" },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", vim.o.tabstop, "-ci" },
        },
      },
    },
  },
  -- linter

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "python" },
    },
  },

  -- test suite
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  },

  -- dap
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      keys = {
        {
          "<leader>dn",
          function() require("dap-python").test_method() end,
          desc = "Debug Method",
          ft = "python",
        },
        {
          "<leader>df",
          function() require("dap-python").test_class() end,
          desc = "Debug Class",
          ft = "python",
        },
      },
      config = function() require("dap-python").setup "debugpy-adapter" end,
    },
  },

  -- extra
}
