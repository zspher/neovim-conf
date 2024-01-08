---@type LazySpec[]
return {
    -- Use <tab> for completion and snippets (supertab)
    -- first: disable default <tab> and <s-tab> behavior in LuaSnip
    {
        "L3MON4D3/LuaSnip",
        --- @diagnostic disable-next-line: assign-type-mismatch
        keys = function()
            return {
                {
                    "<leader>fs",
                    function() require("luasnip.loaders").edit_snippet_files() end,
                    desc = "find snippets",
                },
            }
        end,
        config = function()
            require("luasnip.loaders.from_vscode").load {
                paths = "./snippets",
            }
        end,
    },
    -- then: setup supertab in cmp
    {
        "hrsh7th/nvim-cmp",
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api
                            .nvim_buf_get_lines(0, line - 1, line, true)[1]
                            :sub(col, col)
                            :match "%s"
                        == nil
            end

            local luasnip = require "luasnip"
            local cmp = require "cmp"

            opts.mapping = vim.tbl_extend("force", opts.mapping, {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    -- You could replace the expand_or_jumpable() calls with
                    -- expand_or_locally_jumpable()
                    -- this way you will only jump inside the snippet region
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-n>"] = cmp.mapping(function()
                    if luasnip.choice_active() then
                        luasnip.change_choice(1)
                    elseif cmp.visible() then
                        cmp.select_next_item {
                            behavior = cmp.SelectBehavior.Insert,
                        }
                    end
                end, { "i", "s" }),
                ["<C-p>"] = cmp.mapping(function()
                    if luasnip.choice_active() then
                        luasnip.change_choice(-1)
                    elseif cmp.visible() then
                        cmp.select_prev_item {
                            behavior = cmp.SelectBehavior.Insert,
                        }
                    end
                end, { "i", "s" }),
            })
        end,
    },
    {
        "Exafunction/codeium.nvim",
        cmd = "Codeium",
        build = ":Codeium Auth",
        opts = {},
    },
    {
        "nvim-cmp",
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            table.insert(opts.sources, 1, {
                name = "codeium",
                group_index = 1,
                priority = 100,
            })
        end,
    },
    {
        "danymat/neogen",
        opts = {
            snippet_engine = "luasnip",
        },
        dependencies = {
            "L3MON4D3/LuaSnip",
            {
                "folke/which-key.nvim",
                optional = true,
                opts = {
                    defaults = {
                        ["<leader>n"] = {
                            name = "+Neogen",
                            mode = "n",
                        },
                    },
                },
            },
        },
        keys = {
            {
                "<leader>nf",
                function() require("neogen").generate { type = "func" } end,
                desc = "function",
            },
            {
                "<leader>nc",
                function() require("neogen").generate { type = "class" } end,
                desc = "class",
            },
            {
                "<leader>nt",
                function() require("neogen").generate { type = "type" } end,
                desc = "type",
            },
            {
                "<leader>nF",
                function() require("neogen").generate { type = "file" } end,
                desc = "file",
            },
        },
    },
}
