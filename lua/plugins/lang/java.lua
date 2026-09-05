local function get_jdtls()
  local vue = vim.fn.fnamemodify(vim.fn.exepath "jdtls", ":p:h:h")
  return vim.fs.joinpath(vue, "share/java/jdtls")
end

---@type LazySpec[]
return {
  -- lsp
  {
    "nvim-java/nvim-java",
    ft = { "java" },
    ---@module "java"
    ---@type java.PartialConfig
    opts = {
      jdtls = {
        auto_install = false,
        path = get_jdtls(),
      },
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
      "rcasia/neotest-java",
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
