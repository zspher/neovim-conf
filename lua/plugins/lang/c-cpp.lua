---@type LazySpec[]
return {
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            servers = {
                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--fallback-style=llvm",
                    },
                    init_options = {
                        clangdFileStatus = true,
                    },
                    keys = {
                        {
                            "<leader>ch",
                            "<cmd>LspClangdSwitchSourceHeader<cr>",
                            desc = "Switch Source/Header (C/C++)",
                        },
                    },
                },
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "doxygen", "cpp" },
        },
    },
    {
        "mfussenegger/nvim-dap",
        optional = true,
        opts = function()
            local dap = require "dap"
            for _, lang in ipairs { "c", "cpp" } do
                dap.configurations[lang] = {
                    {
                        type = "codelldb",
                        request = "attach",
                        name = "Attach to process",
                        processId = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                    {
                        name = "Launch file",
                        type = "codelldb",
                        request = "launch",
                        program = function()
                            return vim.fn.input {
                                input = "Path to executable: ",
                                text = vim.fn.getcwd() .. "/",
                                completion = "file",
                            }
                        end,
                        cwd = "${workspaceFolder}",
                        stopOnEntry = false,
                        args = {},
                        env = {
                            UBSAN_OPTIONS = "print_stacktrace=1",
                            ASAN_OPTIONS = "abort_on_error=1:fast_unwind_on_malloc=0:detect_leaks=0",
                        },
                    },
                }
            end
        end,
    },
}
