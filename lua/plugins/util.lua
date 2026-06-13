local save_session = true

---@module 'snacks'
---@type LazySpec[]
return {
  -- Session management. This saves your session in the background,
  -- keeping track of open buffers, window arrangement, and more.
  -- You can restore sessions when returning through the dashboard.
  {
    "stevearc/resession.nvim",
    event = "VimEnter",
    opts = {
      auto_load = true,
      extensions = {
        dap_fixed = {},
        dap_view = {},
      },
    },
    keys = {
      {
        "<leader>ql",
        function()
          require("resession").load(vim.fn.getcwd(), { silence_errors = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qL",
        function() require("resession").load() end,
        desc = "List Sessions",
      },
      {
        "<leader>qs",
        function() require("resession").save(vim.fn.getcwd()) end,
        desc = "Save Current Session",
      },
      {
        "<leader>qd",
        function()
          require("resession").delete(
            vim.fn.getcwd(),
            { silence_errors = true }
          )
          save_session = false
        end,
        desc = "Delete Last Session",
      },
    },
    config = function(_, opts)
      require("resession").setup(opts)
      local resession = require "resession"

      if opts.auto_load then
        vim.api.nvim_create_autocmd("UIEnter", {
          callback = function()
            local is_manpager = vim.list_contains(vim.v.argv, "+Man!")
            if vim.fn.argc(-1) == 0 and not is_manpager then
              vim.schedule(
                function()
                  resession.load(vim.fn.getcwd(), { silence_errors = true })
                end
              )
            end

            if is_manpager then save_session = false end
          end,
        })
      end

      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          if save_session then
            resession.save(vim.fn.getcwd(), { notify = false })
          end
        end,
      })
    end,
  },

  -- library used by other plugins
  -- NOTE: still used by
  --       - neotest & co
  { "nvim-lua/plenary.nvim", enabled = true },
}
