local filetypes = { "hurl" }
---@type LazySpec[]
return {
  {
    "jellydn/hurl.nvim",
    ft = "hurl",
    opts = {
      auto_close = false,
    },
    keys = {
      {
        "<localleader>R",
        "<cmd>HurlRunner<CR>",
        desc = "Run All requests",
        ft = filetypes,
      },
      {
        "<localleader>r",
        "<cmd>HurlRunnerAt<CR>",
        desc = "Run Api request",
        ft = filetypes,
      },
      {
        "<localleader>r",
        ":HurlRunner<CR>",
        mode = { "x" },
        desc = "Run Selected request",
        ft = filetypes,
      },
      {
        "<localleader>l",
        "<cmd>HurlRerun<CR>",
        desc = "Run Last request",
        ft = filetypes,
      },
      {
        "<localleader>L",
        "<cmd>HurlShowLastResponse<CR>",
        desc = "Show Last request",
        ft = filetypes,
      },
    },
  },

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "hurl" },
    },
  },

  {
    "nvim-mini/mini.icons",
    optional = true,
    opts = {
      filetype = {
        hurl = { glyph = "", hl = "MiniIconsRed" },
      },
    },
  },
}
