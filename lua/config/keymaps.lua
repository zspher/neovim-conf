vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

vim.keymap.set("n", "<S-h>", "<S-h>", { desc = "Top line of window" })
vim.keymap.set("n", "<S-l>", "<S-l>", { desc = "Bottom line of window" })
vim.keymap.set("n", "s", "s", { desc = "" })
vim.keymap.set("n", "<S-s>", "<S-s>", { desc = "" })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
