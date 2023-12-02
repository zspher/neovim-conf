return {
  { import = "astrocommunity.test.neotest" },
  {
    "nvim-neotest/neotest",
    keys = function()
      local prefix = "<leader>r"
      return {
        { prefix .. "t", function() require("neotest").run.run(vim.fn.expand "%") end, desc = "Test: Run File" },
        { prefix .. "T", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Test: Run All Test Files" },
        { prefix .. "S", function() require("neotest").summary.toggle() end, desc = "Test: Toggle Summary" },
        { prefix .. "O", function() require("neotest").output_panel.toggle() end, desc = "Test: Toggle Output Panel" },
        { prefix .. "e", function() require("neotest").run.stop() end, desc = "Test: Stop" },
      }
    end,
    opts = function(_, opts)
      opts.adapters = {
        require "neotest-python" {
          dap = { justMyCode = false },
          pytest_discover_instances = true,
        },
      }
      opts.consumers = {
        overseer = require "neotest.consumers.overseer",
      }
    end,
    dependencies = {
      { "stevearc/overseer.nvim", optional = true },
    },
  },
}
