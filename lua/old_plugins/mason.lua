local u = require "utils"

---@type LazySpec[]
return {
    -- disables mason on nixos
    {
        "williamboman/mason.nvim",
        optional = true,
        enabled = not u.is_nixos(),
    },
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            automatic_installation = not u.is_nixos(),
        },
        enabled = not u.is_nixos(),
    },
    {
        "jay-babu/mason-null-ls.nvim",
        optional = true,
        opts = {
            automatic_installation = not u.is_nixos(),
            handlers = {},
        },
        enabled = not u.is_nixos(),
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        optional = true,
        opts = {
            automatic_installation = not u.is_nixos(),
            handlers = {},
        },
        enabled = not u.is_nixos(),
    },
}
