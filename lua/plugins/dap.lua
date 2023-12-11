local function config()
  local dap = require "dap"
  dap.configurations.c = {
    {
      name = "LLDB: Launch",
      type = "codelldb",
      request = "launch",
      program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
      env = {
        UBSAN_OPTIONS = "print_stacktrace=1",
        ASAN_OPTIONS = "abort_on_error=1:fast_unwind_on_malloc=0:detect_leaks=0",
      },
    },
  }
end

return {
  "mfussenegger/nvim-dap",
  config = config(),
}
