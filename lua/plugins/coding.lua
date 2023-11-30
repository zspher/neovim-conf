return {
  { "max397574/better-escape.nvim", enabled = false },
  { import = "astrocommunity.media.vim-wakatime" },
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
      strategy = "toggleterm",
    },
    keys = function()
      local prefix = "<leader>r"
      return {
        { prefix .. "o", "<Cmd>OverseerToggle<cr>", desc = "Task: Open" },
        { prefix .. "t", "<Cmd>OverseerRun<cr>", desc = "Task: Run" },
      }
    end,
    -- config = function(_, opts)
    --   require("overseer").setup(opts)
    --   require("overseer").add_template_hook(
    --     { name = "make" },
    --     function(task_defn, util) util.add_component(task_defn, { "on_output_quickfix", open = true }) end
    --   )
    -- end,
  },
}
