---@type LazySpec[]
return {
    { import = "plugins.lang.bash" },
    { import = "plugins.lang.cs" },
    { import = "plugins.lang.nix" },
    { import = "lazyvim.plugins.extras.lang.tex" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            -- register file type with language
            vim.treesitter.language.register("bash", "zsh")
            -- add more things to the ensure_installed table protecting against community packs modifying it
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "comment" })
                --
            end
        end,
    },
    {
        "mfussenegger/nvim-dap",
        opts = function()
            local dap = require "dap"
            for _, lang in ipairs { "c", "cpp" } do
                dap.configurations[lang] = {
                    {
                        name = "LLDB: Launch",
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

    { import = "lazyvim.plugins.extras.lang.python" },
    {

        "nvim-neotest/neotest",
        opts = function(_, opts)
            opts.adapters = {
                ["neotest-python"] = {
                    dap = { justMyCode = false },
                    pytest_discover_instances = true,
                },
            }
        end,
    },
}
