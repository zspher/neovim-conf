return {
  { import = "lazyvim.plugins.extras.test.core" },
  {
    "nvim-neotest/neotest",
    opts = function(_, opts)
      opts.consumers = {
        overseer = require "neotest.consumers.overseer",
      }
    end,
    dependencies = {
      { "stevearc/overseer.nvim", optional = true },
    },
  },
}
