---@type LazySpec[]
return {
    -- lsp
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
    -- formatter

    -- linter

    -- syntax highlight
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = { "doxygen", "cpp" },
        },
    },

    -- test suite

    -- dap

    {
        "mfussenegger/nvim-dap",
        optional = true,
        opts = function()
            local dap = require "dap"
            local launch
            launch = {
                name = "Launch and replay file",
                type = "codelldb",
                request = "launch",
                cwd = "${workspaceFolder}",
                reverseDebugging = true,
                program = function()
                    local utils = require "dap.utils"
                    local file = utils.pick_file() --[[@as string]]
                    local port = "12345"
                    vim.system {
                        "rr",
                        "record",
                        file,
                    }
                    vim.system { "rr", "replay", "-s", port }
                    launch.processCreateCommands = {
                        "gdb-remote 127.0.0.1:" .. port,
                    }
                    return file
                end,
            }
            for _, lang in ipairs { "c", "cpp" } do
                dap.configurations[lang] = {
                    launch,
                    {
                        name = "Launch file",
                        type = "codelldb",
                        request = "launch",
                        program = "${command:pickFile}",
                        cwd = "${workspaceFolder}",
                        args = {},
                        env = {
                            UBSAN_OPTIONS = "print_stacktrace=1",
                            ASAN_OPTIONS = "abort_on_error=1:fast_unwind_on_malloc=0:detect_leaks=0",
                        },
                    },
                    {
                        type = "codelldb",
                        request = "attach",
                        name = "Attach to process",
                        processId = "${command:pickProcess}",
                        cwd = "${workspaceFolder}",
                    },
                }
            end
        end,
    },
    -- extra
}
