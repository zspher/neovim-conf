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
          ---@type lspconfig.settings.ruff
          settings = {},
        },
        djlsp = {},
      },
    },
  },
  -- formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {},
    },
  },
  -- linter

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "python", "htmldjango" },
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
          python = vim.env.UV_PROJECT_ENVIRONMENT == nil
              and vim.fn.exepath "python"
            or vim.fs.joinpath(vim.env.UV_PROJECT_ENVIRONMENT, "bin", "python"),
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
