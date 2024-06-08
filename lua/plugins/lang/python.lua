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
        "mfussenegger/nvim-dap-python",
        optional = true,
        config = function() require("dap-python").setup "python" end,
    },
}
