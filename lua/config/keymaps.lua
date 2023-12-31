vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")
vim.keymap.del("n", "s")
vim.keymap.del("n", "<S-s>")

vim.keymap.set("n", "<S-h>", "<S-h>", { desc = "Top line of window" })
vim.keymap.set("n", "<S-l>", "<S-l>", { desc = "Bottom line of window" })
vim.keymap.set("n", "s", "s", { desc = "" })
vim.keymap.set("n", "<S-s>", "<S-s>", { desc = "" })

vim.api.nvim_create_user_command("Make", function(params)
  -- Insert args at the '$*' in the makeprg
  local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
  if num_subs == 0 then cmd = cmd .. " " .. params.args end
  local task = require("overseer").new_task {
    cmd = vim.fn.expandcmd(cmd),
    components = {
      { "on_output_quickfix", open = not params.bang, open_height = 8, errorformat = vim.o.efm },
      "default",
    },
  }
  task:start()
end, {
  desc = "Run your makeprg as an Overseer task",
  nargs = "*",
  bang = true,
})
