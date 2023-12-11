return {
  { "echasnovski/mini.indentscope", enabled = false },
  {
    "lukas-reineke/indent-blankline.nvim",
    branch = "current-indent",
    opts = {
      current_indent = { enabled = true, show_start = false, show_end = false, highlight = "RainbowDelimiterBlue" },
    },
    dependencies = {
      "HiPhish/rainbow-delimiters.nvim",
      lazy = true,
      dependencies = "nvim-treesitter/nvim-treesitter",
      event = "LazyFile",
      main = "rainbow-delimiters.setup",
    },
  },
}
