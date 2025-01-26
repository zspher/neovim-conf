---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { "iamcco/markdown-preview.nvim", enabled = false },
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
                ["markdown"] = {},
            },
        },
    },
    {
        "3rd/diagram.nvim",
        dependencies = {
            { "3rd/image.nvim" },
        },
        opts = {},
    },
}
