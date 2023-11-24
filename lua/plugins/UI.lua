return {
  { import = "astrocommunity.editing-support/rainbow-delimiters-nvim" },
  {
    "onsails/lspkind.nvim",
    opts = {
      preset = "codicons",
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
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
      timeout = 2000,
    },
  },
}
