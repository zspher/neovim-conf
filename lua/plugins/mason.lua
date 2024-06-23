---@type LazySpec[]
return {
    -- disables mason on nixos
    {
        "williamboman/mason.nvim",
        optional = true,
        opts = function(_, opts)
            if vim.fn.isdirectory "/nix/var/nix/profiles/system" == 1 then
                opts.ensure_installed = {}
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
            automatic_installation = vim.fn.isdirectory "/nix/var/nix/profiles/system"
                == 0,
        },
        enabled = vim.fn.isdirectory "/nix/var/nix/profiles/system" == 0,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        optional = true,
        opts = {
            automatic_installation = vim.fn.isdirectory "/nix/var/nix/profiles/system"
                == 0,
            handlers = {},
        },
        enabled = vim.fn.isdirectory "/nix/var/nix/profiles/system" == 0,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        optional = true,
        opts = {
            automatic_installation = vim.fn.isdirectory "/nix/var/nix/profiles/system"
                == 0,
            handlers = {},
        },
        enabled = vim.fn.isdirectory "/nix/var/nix/profiles/system" == 0,
    },
}
