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
                ft = { "cs" },
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
        "mfussenegger/nvim-dap",
        optional = true,
        opts = function()
            local function get_dll()
                return coroutine.create(function(dap_run_co)
                    --- @type table
                    --- @diagnostic disable-next-line: assign-type-mismatch
                    local items = vim.fn.globpath(
                        vim.fn.getcwd(),
                        "**/bin/Debug/**/*.dll",
                        0,
                        1 --- @diagnostic disable-line: param-type-mismatch
                    )
                    local opts = {
                        format_item = function(path)
                            return vim.fn.fnamemodify(path, ":t")
                        end,
                    }
                    local function cont(choice)
                        if choice == nil then
                            return nil
                        else
                            coroutine.resume(dap_run_co, choice)
                        end
                    end

                    vim.ui.select(items, opts, cont)
                end)
            end
            local dap = require "dap"
            dap.configurations.cs = {
                {
                    type = "coreclr",
                    name = "NetCoreDbg: Launch",
                    request = "launch",
                    cwd = "${fileDirname}",
                    program = get_dll,
                },
            }
        end,
    },
}
