return {
  { "max397574/better-escape.nvim", enabled = false },
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
        { "r", "<Plug>SnipRun", desc = "REPL: Run", mode = { "v" } },
      }
    end,
  },
}
