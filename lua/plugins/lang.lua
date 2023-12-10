return {
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.markdown-and-latex.vimtex" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- register file type with language
      vim.treesitter.language.register("bash", "zsh")
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        -- "lua"
      })
    end,
  },
}
