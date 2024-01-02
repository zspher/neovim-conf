local function isNixOS()
    if vim.fn.isdirectory "/nix/var/nix/profiles/system" then return false end
    return true
end

return {
    {
        "williamboman/mason.nvim",
        opts = {
            PATH = "append",
        },
        optional = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            automatic_installation = isNixOS(),
        },
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        -- overrides `require("mason-nvim-dap").setup(...)`
        optional = true,
    },
}
