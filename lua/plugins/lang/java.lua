---@type LazySpec[]
return {
  -- lsp
  {
    "nvim-java/nvim-java",
    ft = { "java" },
    ---@module "java"
    ---@type java.PartialConfig
    opts = {
      java_test = {
        path = vim.fn.stdpath "data" .. "/java/test",
      },
      java_debug_adapter = {
        path = vim.fn.stdpath "data" .. "/java/debug",
      },
      spring_boot_tools = {
        enable = false,
      },
      lombok = {
        enable = false,
        path = vim.fn.stdpath "data" .. "/java/lombok.jar",
      },
      jdk = {
        auto_install = false,
      },
    },
    config = function(_, opts)
      require("java").setup(opts)
      vim.lsp.enable "jdtls"
    end,
  },
  -- formatter

  -- linter

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "java" },
    },
  },

  -- test suite
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "zspher/neotest-java", -- TODO: remove when plenary removed
    },
    opts = {
      adapters = {
        ["neotest-java"] = {},
      },
    },
  },

  -- dap
  {
    "mfussenegger/nvim-dap",
    optional = true,
  },

  -- extra
}
