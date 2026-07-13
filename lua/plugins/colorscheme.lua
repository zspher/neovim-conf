---@type LazySpec[]
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    ---@module 'catppuccin'
    ---@type CatppuccinOptions
    opts = {
      float = {
        transparent = true,
        solid = false,
      },
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        harpoon = true,
        lsp_trouble = true,
        neotest = true,
        noice = true,
        notify = true,
        which_key = true,
        treesitter = true,
        snacks = { enabled = true },
        blink_pairs = true,
      },
      custom_highlights = function(c)
        return {
          LineNr = { fg = c.surface2 },
          RenderMarkdownCancelledTask = {
            fg = c.subtext0,
            style = { "strikethrough" },
          },
          RenderMarkdownChecked = { fg = c.mauve },
          CanolaExecutable = { fg = c.red },

          ["@lsp.type.variable"] = { link = "@variable" },
        }
      end,
    },
  },
  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = function(_, opts)
      if (vim.g.colors_name or ""):find "catppuccin" then
        opts.highlights = require("catppuccin.special.bufferline").get_theme()
      end
    end,
  },
}
