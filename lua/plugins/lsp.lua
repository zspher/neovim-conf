---@type LazySpec[]
return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile", "BufWritePre" },
        opts = {
            ---@type vim.diagnostic.Opts
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                    -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
                    -- prefix = "icons",
                },
            },
            ---@type table<string, vim.lsp.Config>
            servers = {},
            codelens = {
                enabled = false,
            },
            inlay_hints = {
                enabled = false,
                exclude = {},
            },
        },
        config = function(_, opts)
            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            -- inlay hints
            if opts.inlay_hints.enabled then
                vim.api.nvim_create_autocmd("LspAttach", {
                    callback = function(args)
                        local buffer = args.buf
                        local client =
                            vim.lsp.get_client_by_id(args.data.client_id)
                        if
                            client
                            and client:supports_method "textDocument/inlayHint"
                            and vim.bo[buffer].buftype == ""
                            and not vim.tbl_contains(
                                opts.inlay_hints.exclude,
                                vim.bo[buffer].filetype
                            )
                        then
                            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
                        end
                    end,
                })
            end

            if vim.lsp.inlay_hint then
                Snacks.toggle.inlay_hints():map "<leader>uh"
            end

            -- code lens
            if opts.codelens.enabled and vim.lsp.codelens then
                vim.api.nvim_create_autocmd("LspAttach", {
                    callback = function(args)
                        local bufnr = args.buf
                        local client =
                            vim.lsp.get_client_by_id(args.data.client_id)
                        if
                            client
                            and client:supports_method "textDocument/codeLens"
                        then
                            vim.lsp.codelens.refresh()
                            vim.api.nvim_create_autocmd(
                                { "BufEnter", "CursorHold", "InsertLeave" },
                                {
                                    buffer = bufnr,
                                    callback = vim.lsp.codelens.refresh,
                                }
                            )
                        end
                    end,
                })
            end

            local function register_keys(client)
                local picker = require "snacks.picker"

                local km = vim.keymap
                km.del("n", "grr")
                km.del({ "n", "x" }, "gra")
                km.del("n", "grn")
                km.del("n", "gri")
                km.del("n", "grt")
                -- stylua: ignore start
                km.set("n", "gd", picker.lsp_definitions, { desc = "Goto Definition" })
                km.set("n", "gr", picker.lsp_references, { desc = "References"})
                km.set("n", "gI", picker.lsp_implementations, { desc = "Goto Implementation" })
                km.set("n", "gy", picker.lsp_type_definitions, { desc = "Goto T[y]pe Definition" })
                km.set("n", "<leader>ss", picker.lsp_symbols, { desc = "LSP Symbols" })
                km.set("n", "<leader>sS", picker.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
                km.set("n", "<leader>cR", Snacks.rename.rename_file, { desc = "Rename File" })
                km.set({"n", "x"},"<leader>ca", vim.lsp.buf.code_action, {desc = "Code Action"})
                km.set("n", "<leader>cr", vim.lsp.buf.rename, {desc = "Rename"})
                -- stylua: ignore end

                local options = require("lazy.core.plugin").values(
                    require("lazy.core.config").spec.plugins["nvim-lspconfig"],
                    "opts",
                    false
                )

                if client == nil then return end
                local maps = options.servers[client.name]
                        and options.servers[client.name].keys
                    or {}

                local keymaps = require("lazy.core.handler.keys").resolve(maps)
                for _, key in pairs(keymaps) do
                    vim.keymap.set(
                        key.mode or "n",
                        key.lhs,
                        key.rhs,
                        { buffer = true }
                    )
                end
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client then return register_keys(client) end
                end,
            })

            local servers = opts.servers
            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local has_blink, blink = pcall(require, "blink.cmp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                has_blink and blink.get_lsp_capabilities() or {},
                opts.capabilities or {}
            )

            local function configure(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, servers[server] or {})

                -- if opts.setup[server] then
                --     if opts.setup[server](server, server_opts) then return true end
                -- elseif opts.setup["*"] then
                --     if opts.setup["*"](server, server_opts) then return true end
                -- end
                vim.lsp.config(server, server_opts)
                vim.lsp.enable(server)
            end

            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    if server_opts.enabled ~= false then configure(server) end
                end
            end
        end,
    },
    -- vim definitions
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "LazyVim", words = { "LazyVim" } },
                { path = "snacks.nvim", words = { "Snacks" } },
                { path = "lazy.nvim", words = { "LazyVim" } },
            },
        },
    },
}
