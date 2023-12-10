return {
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        -- "lua_ls",
        "texlab",
      })
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        -- "prettier",
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        -- "python",
      })
      opts.handlers = {
        codelldb = function(config)
          config.configurations = {
            {
              name = "LLDB: Launch",
              type = "codelldb",
              request = "launch",
              ---@diagnostic disable: redundant-parameter
              program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
              cwd = "${workspaceFolder}",
              stopOnEntry = false,
              args = {},
              env = {
                UBSAN_OPTIONS = "print_stacktrace=1",
                ASAN_OPTIONS = "abort_on_error=1:fast_unwind_on_malloc=0:detect_leaks=0",
              },
            },
          }
        end,
      }
    end,
  },
}
