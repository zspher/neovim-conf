local function get_jdtls()
  local vue = vim.fn.fnamemodify(vim.fn.exepath "jdtls", ":p:h:h")
  return vim.fs.joinpath(vue, "share/java/jdtls")
end

local filetypes = { "java" }

---@type LazySpec[]
return {
  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        gradle_ls = {},
      },
    },
  },
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
    "artur-shaik/jc.nvim",
    ft = { "java" },
    dependencies = { "nvim-java/nvim-java" },
    opts = {
      keys_prefix = "<localleader>",
      default_mappings = false,
      map_gf = false,
    },
    keys = {
      {
        "<localleader>t",
        "<cmd>JCgotoTest<cr>",
        desc = "Goto Related T[e]st",
        ft = filetypes,
      },
      {
        "<localleader>g",
        "<cmd>JCgenerateClass<cr>",
        desc = "Generate Class",
        ft = filetypes,
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "artur-shaik/jc.nvim",
    },
    opts = {
      adapters = {
        ["jc"] = function() return require("jc").neotest_adapter() end,
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
