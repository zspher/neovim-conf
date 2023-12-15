return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          never_show = { ".git" },
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      pickers = {
        find_files = {
          find_command = { "fd", "--type", "f", "--color", "never", "--hidden", "-E", ".git" },
        },
        live_grep = {
          glob_pattern = { "!.git/" },
          additional_args = { "--hidden" },
        },
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        s = "which_key_ignore",
        ["<S-s>"] = "which_key_ignore",
      },
    },
  },
}
