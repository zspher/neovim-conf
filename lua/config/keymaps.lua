vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")
vim.keymap.del("n", "s")
vim.keymap.del("n", "<S-s>")

vim.keymap.set("n", "<S-h>", "<S-h>", { desc = "Top line of window" })
vim.keymap.set("n", "<S-l>", "<S-l>", { desc = "Bottom line of window" })
vim.keymap.set("n", "s", "s", { desc = "" })
vim.keymap.set("n", "<S-s>", "<S-s>", { desc = "" })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- TODO: Remove when dropping support for <Neovim v0.10
if not vim.ui.open then
    vim.keymap.set("n", "gx", function(path)
        -- TODO: REMOVE WHEN DROPPING NEOVIM <0.10
        if vim.ui.open then return vim.ui.open(path) end
        local cmd
        if vim.fn.has "win32" == 1 and vim.fn.executable "explorer" == 1 then
            cmd = { "cmd.exe", "/K", "explorer" }
        elseif vim.fn.has "unix" == 1 and vim.fn.executable "xdg-open" == 1 then
            cmd = { "xdg-open" }
        elseif
            (vim.fn.has "mac" == 1 or vim.fn.has "unix" == 1)
            and vim.fn.executable "open" == 1
        then
            cmd = { "open" }
        end
        vim.fn.jobstart(
            vim.fn.extend(cmd, { path or vim.fn.expand "<cfile>" }),
            { detach = true }
        )
    end, { desc = "Open the file under cursor with system app" })
end
