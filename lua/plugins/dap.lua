return {
  { import = "lazyvim.plugins.extras.dap.core" },
  {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
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
    end,
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debugger: Start" },
      { "<F17>", function() require("dap").terminate() end, desc = "Debugger: Stop" }, -- Shift+F5
      { "<F29>", function() require("dap").restart_frame() end, desc = "Debugger: Restart" }, -- Control+F5
      { "<F6>", function() require("dap").pause() end, desc = "Debugger: Pause" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debugger: Toggle Breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debugger: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debugger: Step Into" },
      { "<F23>", function() require("dap").step_out() end, desc = "Debugger: Step Out" }, -- Shift+F11
    },
  },
}
