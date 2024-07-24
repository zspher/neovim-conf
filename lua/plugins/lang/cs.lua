local function get_roslyn_dll()
    local exe = vim.fn.exepath "Microsoft.CodeAnalysis.LanguageServer"
    -- Find the parent directory of the executable
    local parent_dir = vim.fn.fnamemodify(exe, ":h:h")

    local dir = parent_dir
        .. "/lib/roslyn-ls/Microsoft.CodeAnalysis.LanguageServer.dll"
    return dir
end
---@type LazySpec[]
return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "c_sharp" } },
    },
    {
        "seblj/roslyn.nvim",
        ft = "cs",
        opts = {
            exe = get_roslyn_dll(),
        },
    },
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = {
            "Issafalcon/neotest-dotnet",
        },
        opts = {
            adapters = { ["neotest-dotnet"] = {} },
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
                    type = "coreclr",
                    name = "NetCoreDbg: Launch",
                    request = "launch",
                    cwd = "${fileDirname}",
                    program = get_dll,
                },
            }
        end,
    },
}
