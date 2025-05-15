---@type LazySpec[]
return {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = function(opts, _)
        opts.codelens = {
            enabled = true,
        }
        vim.lsp.enable { "lemminx", "mesonlsp", "harper_ls" }
    end,
}
