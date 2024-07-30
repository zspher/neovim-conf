-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/options.lua

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.signcolumn = "auto"

vim.opt.wrap = false
-- vim.opt.showbreak = "↪ "

vim.opt.tabstop = 4 -- num of spaces displayed for <tab>
vim.opt.shiftwidth = 4 -- for << indent
vim.opt.expandtab = true -- tabs to spaces

vim.opt.conceallevel = 2

vim.opt.list = true
vim.opt.listchars = {
    tab = "│·→",
    extends = "⟩",
    precedes = "⟨",
    lead = "·",
    trail = "·",
    nbsp = "␣",
}

vim.opt.cc = "80"

vim.opt.spell = true

vim.g.mapleader = " "

vim.filetype.add {
    extension = {
        axaml = "xml",
    },
    pattern = {
        [".*/hypr/.+%.conf"] = "hyprlang",
    },
}

vim.g.lazyvim_picker = "fzf"
