LazyVim.on_very_lazy(
    function()
        vim.filetype.add {
            extension = { mdx = "markdown.mdx" },
        }
    end
)
---@type LazySpec[]
return {
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            servers = {
                marksman = {},
            },
        },
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                ["markdown"] = { "markdownlint-cli2" },
                ["markdown.mdx"] = { "markdownlint-cli2" },
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        opts = {
            linters_by_ft = {
                -- i like the formatter but damn is this linter pedantic
                -- ["markdown"] = { "markdownlint-cli2" },
                -- ["markdown.mdx"] = { "markdownlint-cli2" },
            },
        },
    },
}
