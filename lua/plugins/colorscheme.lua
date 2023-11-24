return {
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        nvimtree = false,

        aerial = true,
        leap = true,
        lsp_trouble = true,
        mason = true,
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        overseer = true,
        symbols_outline = true,
        telescope = { enabled = true, style = "nvchad" },
        which_key = true,
      },
    },
  },
}
