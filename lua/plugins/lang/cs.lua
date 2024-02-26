---@type LazySpec[]
return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "c_sharp", "xml" })
            end
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                -- configure omnisharp-vim to use the omnisharp binary from mason
                "OmniSharp/omnisharp-vim",
                config = function()
                    local isNixos = vim.fn.isdirectory "/nix/var/nix/profiles/system"
                        == 1
                    if isNixos then
                        vim.cmd [[
                        let g:OmniSharp_server_path = exepath("OmniSharp")
                    ]]
                    else
                        vim.cmd [[
                        let g:OmniSharp_server_path = exepath("omnisharp")
                    ]]
                    end
                end,
            },
        },
        ---@class PluginLspOpts
        opts = {
            servers = {
                omnisharp = {
                    cmd = { "OmniSharp" },
                    enable_roslyn_analyzers = true,
                    organize_imports_on_format = true,
                    enable_import_completion = true,
                    keys = {
                        -- FIX: https://github.com/OmniSharp/omnisharp-roslyn/issues/2238
                        {
                            "gd",
                            "<cmd>OmniSharpGotoDefinition<CR>",
                            desc = "Goto Definition",
                        },
                        {
                            "gy",
                            "<cmd>OmniSharpGotoTypeDefinition<CR>",
                            desc = "Goto Type Definition",
                        },
                    },
                },
            },
        },
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                -- netcoredbg
                vim.list_extend(opts.ensure_installed, { "coreclr" })
            end
        end,
    },
}
