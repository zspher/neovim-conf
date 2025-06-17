---@type LazySpec[]
return {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    -- FIX: https://github.com/LazyVim/LazyVim/issues/6151
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    opts = function(opts, _)
        opts.codelens = {
            enabled = true,
        }
        vim.lsp.enable { "lemminx", "mesonlsp" }
    end,
    -- TODO: remove `config` when folke fixes this in main
    config = function(_, opts)
        -- setup autoformat
        LazyVim.format.register(LazyVim.lsp.formatter())

        -- setup keymaps
        LazyVim.lsp.on_attach(
            function(client, buffer)
                require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
            end
        )

        LazyVim.lsp.setup()
        LazyVim.lsp.on_dynamic_capability(
            require("lazyvim.plugins.lsp.keymaps").on_attach
        )

        -- inlay hints
        if opts.inlay_hints.enabled then
            LazyVim.lsp.on_supports_method(
                "textDocument/inlayHint",
                function(client, buffer)
                    if
                        vim.api.nvim_buf_is_valid(buffer)
                        and vim.bo[buffer].buftype == ""
                        and not vim.tbl_contains(
                            opts.inlay_hints.exclude,
                            vim.bo[buffer].filetype
                        )
                    then
                        vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
                    end
                end
            )
        end

        -- code lens
        if opts.codelens.enabled and vim.lsp.codelens then
            LazyVim.lsp.on_supports_method(
                "textDocument/codeLens",
                function(client, buffer)
                    vim.lsp.codelens.refresh()
                    vim.api.nvim_create_autocmd(
                        { "BufEnter", "CursorHold", "InsertLeave" },
                        {
                            buffer = buffer,
                            callback = vim.lsp.codelens.refresh,
                        }
                    )
                end
            )
        end

        if
            type(opts.diagnostics.virtual_text) == "table"
            and opts.diagnostics.virtual_text.prefix == "icons"
        then
            opts.diagnostics.virtual_text.prefix = function(diagnostic)
                local icons = LazyVim.config.icons.diagnostics
                for d, icon in pairs(icons) do
                    if
                        diagnostic.severity
                        == vim.diagnostic.severity[d:upper()]
                    then
                        return icon
                    end
                end
            end
        end

        vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

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

            if opts.setup[server] then
                if opts.setup[server](server, server_opts) then return true end
            elseif opts.setup["*"] then
                if opts.setup["*"](server, server_opts) then return true end
            end
            vim.lsp.config(server, server_opts)
            vim.lsp.enable(server)
        end

        for server, server_opts in pairs(servers) do
            if server_opts then
                server_opts = server_opts == true and {} or server_opts
                if server_opts.enabled ~= false then configure(server) end
            end
        end

        if
            LazyVim.lsp.is_enabled "denols" and LazyVim.lsp.is_enabled "vtsls"
        then
            local is_deno = require("lspconfig.util").root_pattern(
                "deno.json",
                "deno.jsonc"
            )
            LazyVim.lsp.disable("vtsls", is_deno)
            LazyVim.lsp.disable("denols", function(root_dir, config)
                if not is_deno(root_dir) then
                    config.settings.deno.enable = false
                end
                return false
            end)
        end
    end,
}
