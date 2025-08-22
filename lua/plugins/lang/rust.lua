---@type LazySpec[]
return {
    -- lsp
    {
        "mrcjkb/rustaceanvim",
        ft = { "rust" },
        opts = {
            server = {
                on_attach = function(_, bufnr)
                    vim.keymap.set(
                        "n",
                        "<leader>cR",
                        function() vim.cmd.RustLsp "codeAction" end,
                        { desc = "Code Action", buffer = bufnr }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>dr",
                        function() vim.cmd.RustLsp "debuggables" end,
                        { desc = "Rust Debuggables", buffer = bufnr }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>ct",
                        function() vim.cmd.RustLsp "runnables" end,
                        { desc = "Rust run task", buffer = bufnr }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>cT",
                        function() vim.cmd.RustLsp { "runnables", bang = true } end,
                        { desc = "Rust restart task", buffer = bufnr }
                    )
                end,
                default_settings = {
                    -- rust-analyzer language server configuration
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            buildScripts = {
                                enable = true,
                            },
                        },
                        -- Add clippy lints for Rust if using rust-analyzer
                        checkOnSave = true,
                        -- Enable diagnostics if using rust-analyzer
                        diagnostics = {
                            enable = true,
                        },
                        procMacro = {
                            enable = true,
                            ignored = {
                                ["async-trait"] = { "async_trait" },
                                ["napi-derive"] = { "napi" },
                                ["async-recursion"] = { "async_recursion" },
                            },
                        },
                        files = {
                            excludeDirs = {
                                ".direnv",
                                ".git",
                                ".github",
                                ".gitlab",
                                "bin",
                                "node_modules",
                                "target",
                                "venv",
                                ".venv",
                            },
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            local codelldb = vim.fn.exepath "codelldb"
            local codelldb_lib_ext = io.popen("uname"):read "*l" == "Linux"
                    and ".so"
                or ".dylib"
            local library_path =
                vim.fn.expand("$MASON/opt/lldb/lib/liblldb" .. codelldb_lib_ext)
            opts.dap = {
                adapter = require("rustaceanvim.config").get_codelldb_adapter(
                    codelldb,
                    library_path
                ),
            }
            vim.g.rustaceanvim = vim.tbl_deep_extend(
                "keep",
                vim.g.rustaceanvim or {},
                opts or {}
            )
        end,
    },
    {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
            completion = {
                crates = {
                    enabled = true,
                },
            },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
        },
    },

    -- formatter

    -- linter

    -- syntax highlight
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "rust", "ron" } },
    },

    -- test suite
    {
        "nvim-neotest/neotest",
        optional = true,
        opts = {
            adapters = {
                ["rustaceanvim.neotest"] = {},
            },
        },
    },

    -- dap

    -- extra
}
