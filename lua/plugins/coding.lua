---@module 'snacks'
---@type LazySpec[]
return {
    -- auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
        keys = {
            {
                "<leader>up",
                function()
                    local Util = require "lazy.core.util"
                    require("nvim-autopairs").state.disabled =
                        not require("nvim-autopairs").state.disabled
                    if require("nvim-autopairs").state.disabled then
                        Util.warn("Disabled auto pairs", { title = "Option" })
                    else
                        Util.info("Enabled auto pairs", { title = "Option" })
                    end
                end,
                desc = "Toggle auto pairs",
            },
        },
    },

    -- comments
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {
            lang = {
                typst = {
                    "// %s", -- default commentstring when no treesitter node matches
                    "/* %s */",
                },
            },
        },
    },
    {
        "danymat/neogen",
        cmd = "Neogen",
        keys = {
            {
                "<leader>cn",
                function() require("neogen").generate() end,
                desc = "Generate Annotations (Neogen)",
            },
        },
        opts = {
            snippets_engine = "luasnip",
        },
    },

    -- better text objects

    -- autocomplete
    {
        "L3MON4D3/LuaSnip",
        lazy = true,
        dependencies = {
            {
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                    require("luasnip.loaders.from_vscode").lazy_load {
                        paths = { vim.fn.stdpath "config" .. "/snippets" },
                    }
                end,
            },
        },
        opts = {
            enable_autosnippets = true,
            cut_selection_keys = "<C-j>",
            history = true,
            delete_check_events = "TextChanged",
        },
        keys = {
            {
                "<C-j>",
                function() vim.snippet.jump(1) end,
                mode = { "s", "i" },
            },
            {
                "<C-k>",
                function() vim.snippet.jump(-1) end,
                mode = { "i", "s" },
            },
            {
                "<C-n>",
                function() require("luasnip").change_choice(1) end,
                mode = { "i", "s" },
            },
            {
                "<C-p>",
                function() require("luasnip").change_choice(-1) end,
                mode = { "i", "s" },
            },
        },
    },
    {
        "L3MON4D3/LuaSnip",
        optional = true,
        opts = function(_, opts)
            local types = require "luasnip.util.types"
            opts.ext_opts = {
                [types.choiceNode] = {
                    active = {
                        hl_group = "SnippetTabStop",
                        virt_text = { { "{𝖢}", "Title" } },
                    },
                },
            }
        end,
    },
    {
        "saghen/blink.cmp",
        event = "InsertEnter",
        version = "*",
        opts_extend = {
            "sources.completion.enabled_providers",
            "sources.compat",
            "sources.default",
        },
        dependencies = {
            "rafamadriz/friendly-snippets",
            "L3MON4D3/LuaSnip",
            -- add blink.compat to dependencies
            {
                "saghen/blink.compat",
                optional = true, -- make optional so it's only enabled if any extras need it
                opts = {},
                version = not vim.g.lazyvim_blink_main and "*",
            },
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            snippets = {},
            appearance = {
                -- sets the fallback highlight groups to nvim-cmp's highlight groups
                -- useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release, assuming themes add support
                use_nvim_cmp_as_default = false,
                -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },
            completion = {
                menu = {
                    draw = {
                        treesitter = { "lsp" },
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "source_name" },
                        },
                        components = {
                            source_name = {
                                text = function(ctx)
                                    return "[" .. ctx.source_name .. "]"
                                end,
                            },
                        },
                    },
                },
                accept = {
                    -- experimental auto-brackets support
                    auto_brackets = {
                        enabled = true,
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                ghost_text = {
                    enabled = vim.g.ai_cmp,
                },
            },

            -- experimental signature help support
            -- signature = { enabled = true },

            sources = {
                -- adding any nvim-cmp sources here will enable them
                -- with blink.compat
                compat = {},
                default = { "lsp", "path", "snippets", "buffer" },
            },
            cmdline = {
                enabled = true,
            },
            keymap = {
                preset = "default",
                ["<C-j>"] = { "snippet_forward", "fallback" },
                ["<C-k>"] = {
                    "show_signature",
                    "hide_signature",
                    "snippet_backward",
                    "fallback",
                },

                ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
                ["<C-n>"] = { "select_next", "fallback_to_mappings" },
            },
        },
        config = function(_, opts)
            -- setup compat sources
            local enabled = opts.sources.default
            for _, source in ipairs(opts.sources.compat or {}) do
                opts.sources.providers[source] = vim.tbl_deep_extend(
                    "force",
                    { name = source, module = "blink.compat.source" },
                    opts.sources.providers[source] or {}
                )
                if
                    type(enabled) == "table"
                    and not vim.tbl_contains(enabled, source)
                then
                    table.insert(enabled, source)
                end
            end

            -- Unset custom prop to pass blink.cmp validation
            opts.sources.compat = nil

            require("blink.cmp").setup(opts)
        end,
    },

    -- refactoring
    {
        "ThePrimeagen/refactoring.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            { "<leader>r", "", desc = "+refactor", mode = { "n", "x" } },
            {
                "<leader>rI",
                function() require("refactoring").refactor "Inline Function" end,
                desc = "Inline Function",
            },
            {
                "<leader>ri",
                function()
                    return require("refactoring").refactor "Inline Variable"
                end,
                mode = { "n", "x" },
                desc = "Inline Variable",
                expr = true,
            },
            {
                "<leader>rb",
                function()
                    return require("refactoring").refactor "Extract Block"
                end,
                mode = { "n", "x" },
                desc = "Extract Block",
                expr = true,
            },
            {
                "<leader>rf",
                function()
                    return require("refactoring").refactor "Extract Block To File"
                end,
                mode = { "n", "x" },
                desc = "Extract Block To File",
                expr = true,
            },
            {
                "<leader>rP",
                function()
                    require("refactoring").debug.printf { below = false }
                end,
                desc = "Debug Print",
            },
            {
                "<leader>rp",
                function()
                    require("refactoring").debug.print_var { normal = true }
                end,
                mode = { "n", "x" },
                desc = "Debug Print Variable",
            },
            {
                "<leader>rc",
                function() require("refactoring").debug.cleanup {} end,
                desc = "Debug Cleanup",
            },
            {
                "<leader>rf",
                function()
                    return require("refactoring").refactor "Extract Function"
                end,
                mode = { "n", "x" },
                desc = "Extract Function",
                expr = true,
            },
            {
                "<leader>rF",
                function()
                    return require("refactoring").refactor "Extract Function To File"
                end,
                mode = { "n", "x" },
                desc = "Extract Function To File",
                expr = true,
            },
            {
                "<leader>rx",
                function()
                    return require("refactoring").refactor "Extract Variable"
                end,
                mode = { "n", "x" },
                desc = "Extract Variable",
                expr = true,
            },
            {
                "<leader>rp",
                function() require("refactoring").debug.print_var() end,
                mode = { "n", "x" },
                desc = "Debug Print Variable",
            },
        },
        opts = {
            prompt_func_return_type = {
                go = false,
                java = false,
                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            prompt_func_param_type = {
                go = false,
                java = false,
                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            printf_statements = {},
            print_var_statements = {},
            show_success_message = true, -- shows a message with information about the refactor on success
        },
    },
}
