---@type LazySpec[]
return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "rust" })
            end
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^4",
        ft = { "rust" },
        opts = {
            server = {
                default_settings = {
                    -- rust-analyzer language server configuration
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            runBuildScripts = true,
                        },
                        -- Add clippy lints for Rust.
                        checkOnSave = {
                            allFeatures = true,
                            command = "clippy",
                            extraArgs = { "--no-deps" },
                        },
                        procMacro = {
                            enable = true,
                        },
                        completion = {
                            postfix = {
                                enable = false,
                            },
                        },
                    },
                },
            },
            dap = {
                autoload_configurations = true,
            },
        },
        config = function(_, opts)
            vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
        end,
    },
    {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
            lsp = {
                enabled = true,
                name = "crates.nvim",
                actions = true,
                completion = true,
                hover = true,
            },
        },
    },
    {
        "nvim-neotest/neotest",
        optional = true,
        opts = function(_, opts)
            if not opts.adapters then opts.adapters = {} end
            local rustaceanvim_avail, rustaceanvim =
                pcall(require, "rustaceanvim.neotest")
            if rustaceanvim_avail then
                table.insert(opts.adapters, rustaceanvim)
            end
        end,
    },
}
