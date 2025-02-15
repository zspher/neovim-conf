---@type LazySpec[]
return {

    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "c_sharp" } },
    },
    {
        "seblj/roslyn.nvim",
        ft = "cs",
        -- TODO: remove when https://github.com/NixOS/nixpkgs/pull/379787 drops
        commit = "490fd2d0f76249032ef6ce503e43ccdaeed9616e",

        ---@module 'roslyn'
        ---@type RoslynNvimConfig
        opts = {
            exe = "Microsoft.CodeAnalysis.LanguageServer",
            ---@diagnostic disable-next-line: missing-fields
            config = {},
        },
    },
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = { -- TODO: remove when vstest integ is merged in main
            "Nsidorenco/neotest-dotnet",
            branch = "test-runner",
        },
        opts = {
            adapters = { ["neotest-dotnet"] = {} },
        },
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                cs = { "csharpier" },
            },
        },
    },
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
                        1
                    )
                    local opts = {
                        format_item = function(path)
                            return vim.fn.fnamemodify(path, ":t")
                        end,
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
}
