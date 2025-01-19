local function is_nixos()
    return vim.fn.isdirectory "/nix/var/nix/profiles/system" == 1
end

---@type LazySpec[]
return {
    -- disables mason on nixos
    {
        "williamboman/mason.nvim",
        optional = true,
        opts = function(_, opts)
            if is_nixos() then
                -- TODO: remove when package is available in nixos
                -- so just install via mason
                opts.ensure_installed = { "markuplint", "debugpy" }
            end
            return {
                ensure_installed = opts.ensure_installed,
                PATH = "append",
            }
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            automatic_installation = not is_nixos(),
        },
        enabled = not is_nixos(),
    },
    {
        "jay-babu/mason-null-ls.nvim",
        optional = true,
        opts = {
            automatic_installation = not is_nixos(),
            handlers = {},
        },
        enabled = not is_nixos(),
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        optional = true,
        opts = {
            automatic_installation = not is_nixos(),
            handlers = {},
        },
        enabled = not is_nixos(),
    },
}
