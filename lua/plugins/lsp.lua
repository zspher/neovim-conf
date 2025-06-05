---@type LazySpec[]
return {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    -- FIX: https://github.com/LazyVim/LazyVim/issues/6151
    event = vim.fn.has "nvim-0.11" == 1
            and { "BufReadPre", "BufNewFile", "BufWritePre" }
        or { "LazyFile" },
    opts = function(opts, _)
        opts.codelens = {
            enabled = true,
        }
        vim.lsp.enable { "lemminx", "mesonlsp" }
    end,
}
