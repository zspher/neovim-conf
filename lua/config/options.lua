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
vim.opt.listchars:append { tab = "│→", extends = "⟩", precedes = "⟨", trail = "·", nbsp = "␣" }

vim.opt.cc = "80"

vim.opt.spell = true
vim.opt.spellfile = vim.fn.expand "~/.config/nvim/spell/en.utf-8.add"
vim.opt.thesaurus = vim.fn.expand "~/.config/nvim/spell/mthesaur.txt"

vim.g.mapleader = " "
