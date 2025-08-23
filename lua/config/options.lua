-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/AstroNvim/AstroNvim/blob/main/lua/astronvim/options.lua

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.signcolumn = "yes"
vim.opt.cc = "80"
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.opt.wrap = false
vim.opt.laststatus = 3 -- global statusline
vim.opt.cursorline = true
vim.opt.sessionoptions = {
    "buffers",
    "curdir",
    "tabpages",
    "winsize",
    "help",
    "globals",
    "skiprtp",
    "folds",
}

vim.schedule(
    function() vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" end
)

vim.opt.showbreak = "↪ "
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

vim.opt.spell = true
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smoothscroll = true

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.g.mapleader = " "
vim.g.snacks_animate = false
