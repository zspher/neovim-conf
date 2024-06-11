---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.lang.omnisharp" },
    {
        "nvimtools/none-ls.nvim",
        optional = true,
        opts = function(_, opts)
            local nls = require "null-ls"
            local last_elem = opts.sources[#opts.sources]
            if last_elem == nls.builtins.formatting.csharpier then
                table.remove(opts.sources)
            end
        end,
    },
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            servers = {
                omnisharp = {
                    cmd = { "OmniSharp" },
                    keys = {
                        {
                            "gd",
                            function()
                                require("omnisharp_extended").telescope_lsp_definitions {
                                    reuse_win = true,
                                }
                            end,
                            desc = "Goto Definition",
                        },
                        {
                            "gr",
                            function()
                                require("omnisharp_extended").telescope_lsp_references()
                            end,
                            desc = "References",
                        },
                        {
                            "gI",
                            function()
                                require("omnisharp_extended").telescope_lsp_implementation {
                                    reuse_win = true,
                                }
                            end,
                            desc = "Goto Implementation",
                        },
                        {
                            "gy",
                            function()
                                require("omnisharp_extended").telescope_lsp_type_definition {
                                    reuse_win = true,
                                }
                            end,
                            desc = "Goto T[y]pe Definition",
                        },
                    },
                },
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
