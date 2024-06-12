local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
local on_attach = function() end
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
        "benjiwolff/roslyn.nvim",
        branch = "allow-custom-roslyn-dll-path",
        ft = "cs",
        config = function()
            require("roslyn").setup {
                dotnet_cmd = "dotnet", -- this is the default
                roslyn_version = "4.10.0-2.24124.2", -- this is the default
                on_attach = on_attach,
                capabilities = capabilities,
                roslyn_lsp_dll_path = get_roslyn_dll(),
            }
        end,
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
