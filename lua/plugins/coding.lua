return {
  { "wakatime/vim-wakatime", event = "LazyFile" },
  { import = "lazyvim.plugins.extras.coding.codeium" },
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gvdiffsplit",
      "Gedit",
      "Gsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "Glgrep",
      "Gmove",
      "Gdelete",
      "Gremove",
      "Gbrowse",
    },
  },
  {
    "michaelb/sniprun",
    build = "bash ./install.sh 1",
    opts = {
      interpreter_options = {
        Generic = {
          racket_config = {
            supported_filetypes = { "racket" },
            extension = ".rkt",
            interpreter = "racket",
            boilerplate_pre = "#lang racket",
          },
        },
      },
      inline_messages = true,
    },
    keys = function()
      local prefix = "<leader>r"
      return {
        { prefix .. "r", "<Plug>SnipRunOperator", desc = "REPL: Run" },
        { prefix .. "c", "<Plug>SnipClose", desc = "REPL: Clear" },
        { prefix .. "l", "<Plug>SnipRun", desc = "REPL: Run line" },
        { prefix, "<Plug>SnipRun", desc = "REPL: Run", mode = { "v" } },
      }
    end,
    dependencies = {
      "folke/which-key.nvim",
      optional = true,
      opts = { defaults = { ["<leader>r"] = { name = "+run/task", mode = "n" } } },
    },
  },
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerSaveBundle",
      "OverseerLoadBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction ",
      "OverseerClearCache",
    },
    opts = {
      component_aliases = {
        -- Most tasks are initialized with the default components
        default = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_notify",
          "on_complete_dispose",
          { "on_output_quickfix", close = true },
        },
      },
    },
    keys = function()
      local prefix = "<leader>r"
      return {
        { prefix .. "o", "<Cmd>OverseerToggle<cr>", desc = "Task: Open" },
        { prefix .. "t", "<Cmd>OverseerRun<cr>", desc = "Task: Run" },
      }
    end,
    dependencies = {
      "folke/which-key.nvim",
      optional = true,
      opts = { defaults = { ["<leader>r"] = { name = "+run/task", mode = "n" } } },
    },
    -- config = function(_, opts)
    --   require("overseer").setup(opts)
    --   require("overseer").add_template_hook(
    --     { name = "make" },
    --     function(task_defn, util) util.add_component(task_defn, { "on_output_quickfix", open = true }) end
    --   )
    -- end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    keys = function()
      local prefix = "<leader>c"
      return {
        {
          prefix .. "e",
          mode = { "v" },
          function() require("refactoring").refactor "Extract Function" end,
          desc = "Extract Function",
        },
        {
          prefix .. "E",
          mode = { "v" },
          function() require("refactoring").refactor "Extract Function To File" end,
          desc = "Extract Function to File",
        },
        {
          prefix .. "v",
          mode = { "v" },
          function() require("refactoring").refactor "extract variable" end,
          desc = "Extract Variable",
        },
        {
          prefix .. "I",
          function() require("refactoring").refactor "Inline Function" end,
          desc = "Inline Function",
        },
        {
          prefix .. "i",
          mode = { "v", "n" },
          function() require("refactoring").refactor "Inline Variable" end,
          desc = "Inline Variable",
        },
        {
          prefix .. "b",
          function() require("refactoring").refactor "Extract Block" end,
          desc = "Extract Block",
        },
        {
          prefix .. "B",
          function() require("refactoring").refactor "Extract Block To File" end,
          desc = "Extract Block to File",
        },
      }
    end,
  },

  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  { "L3MON4D3/LuaSnip", keys = function() return {} end },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end

      local luasnip = require "luasnip"
      local cmp = require "cmp"

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
}
