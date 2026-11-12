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
      {
        "nsidorenco/neotest-vstest",
        init = function()
          vim.g.neotest_vstest = {
            dap_settings = {
              type = "coreclr",
              console = "integratedTerminal",
              cwd = "${fileDirname}",
            },
          }
        end,
      },
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
      local dap = require "dap"
      local function get_target_path()
        return coroutine.create(function(dap_run_co)
          local csproj = vim.fs.find(
            function(name) return name:match "%.csproj$" ~= nil end,
            {
              path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
              upward = true,
              type = "file",
              limit = 1,
            }
          )

          if not csproj[1] then
            vim.notify(
              "No .csproj found near current file",
              vim.log.levels.ERROR
            )
            coroutine.resume(dap_run_co, dap.ABORT)
            return
          end

          vim.system(
            { "dotnet", "msbuild", csproj[1], "-getProperty:TargetPath" },
            { text = true },
            function(obj)
              vim.schedule(function()
                if obj.code ~= 0 then
                  vim.notify(
                    string.format(
                      "msbuild failed (%d): %s",
                      obj.code,
                      vim.trim(obj.stderr or "")
                    ),
                    vim.log.levels.ERROR
                  )
                  coroutine.resume(dap_run_co, dap.ABORT)
                  return
                end

                coroutine.resume(dap_run_co, (vim.trim(obj.stdout or "")))
              end)
            end
          )
        end)
      end

      local web_launch = {
        type = "coreclr",
        name = "coreclr: Launch (web)",
        request = "launch",
        program = get_target_path,
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
          program = get_target_path,
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
