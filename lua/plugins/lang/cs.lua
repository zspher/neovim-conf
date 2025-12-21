---@type LazySpec[]
return {
  -- lsp
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      silent = true,
      filewatching = "off",
    },
    init = function()
      vim.filetype.add {
        extension = {
          razor = "razor",
          cshtml = "razor",
        },
      }
    end,
  },
  -- formatter
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- use lsp formatter for now
        -- cs = { "csharpier" },
      },
    },
  },
  -- linter

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c_sharp", "razor" } },
  },

  -- test suite
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nsidorenco/neotest-vstest",
    },
    opts = {
      adapters = {
        ["neotest-vstest"] = {},
      },
    },
  },

  -- dap
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local function get_dll()
        return coroutine.create(function(dap_run_co)
          local items = vim.fn.globpath(
            vim.fn.getcwd(),
            "**/bin/Debug/**/*.dll",
            true,
            true
          )
          local opts = {
            format_item = function(path) return vim.fn.fnamemodify(path, ":t") end,
          }
          local function cont(choice)
            if choice == nil then
              return nil
            else
              coroutine.resume(dap_run_co, choice)
            end
          end

          vim.ui.select(items, opts, cont)
        end)
      end
      local dap = require "dap"
      dap.configurations.cs = {
        {
          type = "netcoredbg",
          name = "NetCoreDbg: Launch",
          request = "launch",
          cwd = "${fileDirname}",
          program = get_dll,
        },
        {
          type = "coreclr",
          name = "coreclr: Launch",
          request = "launch",
          program = get_dll,
          args = {},
          cwd = "${fileDirname}",
          console = "integratedTerminal",
        },
        {
          type = "coreclr",
          name = "coreclr: Launch (web)",
          request = "launch",
          program = get_dll,
          args = {},
          cwd = "${fileDirname}",
          console = "integratedTerminal",
          stopAtEntry = false,
          serverReadyAction = {
            action = "openExternally",
            pattern = "\\bNow listening on:\\s+(https?://\\S+)",
          },
          env = {
            ASPNETCORE_ENVIRONMENT = "Development",
          },
          sourceFileMap = {
            ["/Views"] = "${workspaceFolder}/Views",
          },
        },
      }
    end,
  },

  -- extra
}
