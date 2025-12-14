-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">"
      or vim.schedule(function() vim.cmd.wincmd(dir) end)
  end
end

---@module 'snacks'

---@type LazySpec[]
return {
  -- Snacks utils
  {
    "snacks.nvim",
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      terminal = {
        win = {
          keys = {
            nav_h = {
              "<C-h>",
              term_nav "h",
              desc = "Go to Left Window",
              expr = true,
              mode = "t",
            },
            nav_j = {
              "<C-j>",
              term_nav "j",
              desc = "Go to Lower Window",
              expr = true,
              mode = "t",
            },
            nav_k = {
              "<C-k>",
              term_nav "k",
              desc = "Go to Upper Window",
              expr = true,
              mode = "t",
            },
            nav_l = {
              "<C-l>",
              term_nav "l",
              desc = "Go to Right Window",
              expr = true,
              mode = "t",
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>.",
        function() Snacks.scratch() end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>S",
        function() Snacks.scratch.select() end,
        desc = "Select Scratch Buffer",
      },
      {
        "<leader>dps",
        function() Snacks.profiler.scratch() end,
        desc = "Profiler Scratch Buffer",
      },
      {
        "<leader>ft",
        function() Snacks.terminal() end,
        desc = "Terminal (cwd)",
      },
      {
        "<c-/>",
        function() Snacks.terminal() end,
        desc = "Terminal (cwd)",
        mode = { "n", "t" },
      },
    },
  },
  -- snacks toggles
  {
    "snacks.nvim",
    opts = function()
      Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
      Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
      Snacks.toggle
        .option("relativenumber", { name = "Relative Number" })
        :map "<leader>uL"
      Snacks.toggle.diagnostics():map "<leader>ud"
      Snacks.toggle.line_number():map "<leader>ul"
      Snacks.toggle
        .option("conceallevel", {
          off = 0,
          on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
          name = "Conceal Level",
        })
        :map "<leader>uc"
      Snacks.toggle
        .option("showtabline", {
          off = 0,
          on = vim.o.showtabline > 0 and vim.o.showtabline or 2,
          name = "Tabline",
        })
        :map "<leader>uA"
      Snacks.toggle.treesitter():map "<leader>uT"
      Snacks.toggle
        .option("background", { off = "light", on = "dark", name = "Dark Background" })
        :map "<leader>ub"
      Snacks.toggle.dim():map "<leader>uD"
      Snacks.toggle.animate():map "<leader>ua"
      Snacks.toggle.indent():map "<leader>ug"
      Snacks.toggle.scroll():map "<leader>uS"
      Snacks.toggle.profiler():map "<leader>dpp"
      Snacks.toggle.profiler_highlights():map "<leader>dph"
      Snacks.toggle.zoom():map("<leader>wm"):map "<leader>uZ"
      Snacks.toggle.zen():map "<leader>uz"
    end,
  },

  -- Session management. This saves your session in the background,
  -- keeping track of open buffers, window arrangement, and more.
  -- You can restore sessions when returning through the dashboard.
  {
    "folke/persistence.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>qs",
        function() require("persistence").load() end,
        desc = "Restore Session",
      },
      {
        "<leader>qS",
        function() require("persistence").select() end,
        desc = "Select Session",
      },
      {
        "<leader>ql",
        function() require("persistence").load { last = true } end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function() require("persistence").stop() end,
        desc = "Don't Save Current Session",
      },
      {
        "<leader>qD",
        function()
          require("persistence").stop()
          vim.fn.delete(require("persistence").current())
        end,
        desc = "Delete Current Session",
      },
    },
    config = function(_, opts)
      require("persistence").setup(opts)
      vim.schedule(function() require("persistence").load() end)
    end,
  },

  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },
}
