vim.schedule(
  function() vim.o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" end
)

vim.opt.listchars = {
  tab = "│·→",
  extends = "⟩",
  precedes = "⟨",
  lead = "·",
  trail = "·",
  nbsp = "␣",
}

vim.o.cc = "80"
vim.o.conceallevel = 2
vim.o.cursorline = true
vim.o.expandtab = true -- tabs to spaces
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldtext = ""
vim.o.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.laststatus = 3 -- global statusline
vim.o.list = true
vim.o.mouse = "a"
vim.o.number = true
vim.o.relativenumber = true
vim.o.sessionoptions =
  "buffers,curdir,folds,help,tabpages,terminal,winpos,winsize,localoptions"
vim.o.shiftwidth = 4 -- for << indent
vim.o.showmode = false -- Dont show mode since we have a statusline
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.smoothscroll = true
vim.o.spell = true
vim.o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
vim.o.tabstop = 4 -- num of spaces displayed for <tab>
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.wrap = false
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.snacks_animate = false
