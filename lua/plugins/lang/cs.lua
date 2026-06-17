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
    },
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

          if #items == 1 then
            coroutine.resume(dap_run_co, items[1])
            return
          end
          vim.ui.select(items, {
            format_item = function(path) return vim.fn.fnamemodify(path, ":t") end,
          }, function(choice)
            if choice then coroutine.resume(dap_run_co, choice) end
          end)
        end)
      end
      local dap = require "dap"

      local web_launch = {
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
      }
      dap.configurations.razor = { web_launch }
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "coreclr: Launch",
          request = "launch",
          program = get_dll,
          args = {},
          cwd = "${fileDirname}",
          console = "integratedTerminal",
        },
        web_launch,
      }
    end,
  },

  -- extra
}
