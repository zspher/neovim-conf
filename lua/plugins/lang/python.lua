---@type LazySpec[]
return {
    { import = "lazyvim.plugins.extras.lang.python" },
    {
        "nvim-neotest/neotest",
        optional = true,
        opts = {
            adapters = {
                ["neotest-python"] = {
                    dap = { justMyCode = false },
                    pytest_discover_instances = true,
                },
            },
        },
    },
    {

        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = function()
            vim.lsp.enable "pyright"
            vim.lsp.config("pyright", {
                settings = {
                    python = { analysis = { typeCheckingMode = "strict" } },
                },
            })
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        -- to get rid of the mason debugpy not found message
        config = function() end,
    },
}
