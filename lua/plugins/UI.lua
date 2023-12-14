local Util = require "lazyvim.util"
local icons = require("lazyvim.config").icons
return {
  { import = "lazyvim.plugins.extras.editor.aerial" },
  { -- overrides parts of aerial config
    "nvim-lualine/lualine.nvim",
    opts = {
      options = { section_separators = "", component_separators = { left = "›", right = "|" } },
      sections = {
        lualine_c = {
          Util.lualine.root_dir(),
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
        },
      },
      winbar = {
        lualine_c = {
          { Util.lualine.pretty_path() },
          {
            "aerial",
            sep = " › ", -- separator between symbols
            sep_icon = "", -- separator between icon and symbol

            -- The number of symbols to render top-down. In order to render only 'N' last
            -- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
            -- be used in order to render only current symbol.
            depth = 5,

            -- When 'dense' mode is on, icons are not rendered near their symbols. Only
            -- a single icon that represents the kind of current symbol is rendered at
            -- the beginning of status line.
            dense = false,

            -- The separator to be used to separate symbols in dense mode.
            dense_sep = ".",

            -- Color the symbol icons.
            colored = true,
          },
        },
      },
    },
  },
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
