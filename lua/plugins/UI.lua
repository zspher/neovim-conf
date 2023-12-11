return {
  { import = "astrocommunity.editing-support/rainbow-delimiters-nvim" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          never_show = {
            ".git",
          },
        },
      },
    },
  },
  {
    "onsails/lspkind.nvim",
    opts = {
      preset = "codicons",
      symbol_map = { Codeium = "" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "flex",
        layout_config = {
          preview_cutoff = 0,
          flex = { flip_columns = 106 },
          horizontal = { prompt_position = "top", preview_width = 0.55 },
          vertical = { prompt_position = "bottom", mirror = false },
        },
      },
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
    },
  },
}
