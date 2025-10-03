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
    dependencies = {
      {
        "tris203/rzls.nvim",
        opts = {
          path = "rzls",
        },
      },
    },
    config = function(_, opts)
      local rzls_path =
        vim.fn.fnamemodify(vim.fn.resolve(vim.fn.exepath "rzls"), ":h:h")
      local cmd = {
        "roslyn-ls",
        "--stdio",
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--razorSourceGenerator=" .. vim.fs.joinpath(
          rzls_path,
          ".razor",
          "Microsoft.CodeAnalysis.Razor.Compiler.dll"
        ),
        "--razorDesignTimePath=" .. vim.fs.joinpath(
          rzls_path,
          ".razor",
          "Targets",
          "Microsoft.NET.Sdk.Razor.DesignTime.targets"
        ),
        "--extension",
        vim.fs.joinpath(
          rzls_path,
          ".razorExtension",
          "Microsoft.VisualStudioCode.RazorExtension.dll"
        ),
      }

      vim.lsp.config("roslyn", {
        filetypes = { "cs" },
        cmd = cmd,
        handlers = require "rzls.roslyn_handlers",
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,

            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      })
      require("roslyn").setup(opts)
    end,
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
      }
    end,
  },

  -- extra
}
