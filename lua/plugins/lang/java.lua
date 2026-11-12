local function get_jdtls()
  local path = vim.fn.fnamemodify(vim.fn.exepath "jdtls", ":p:h:h")
  return vim.fs.joinpath(path, "share/java/jdtls")
end

local filetypes = { "java" }

---@type LazySpec[]
return {
  -- lsp
  {
    "neovim/nvim-lspconfig",
    optional = true,
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
    opts = function()
      local dap = require "dap"

      local function get_port()
        return coroutine.create(function(dap_run_co)
          vim.ui.input({
            default = "8787",
          }, function(input)
            coroutine.resume(dap_run_co, tonumber(input))
          end)
        end)
      end
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Attach to remote",
          hostName = "127.0.0.1",
          port = get_port,
        },
      }
    end,
  },

  -- extra
}
