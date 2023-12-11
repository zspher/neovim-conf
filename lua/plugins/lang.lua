return {
  { import = "plugins.lang.bash" },
  { import = "lazyvim.plugins.extras.lang.tex" },
  { import = "lazyvim.plugins.extras.lang.clangd" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- register file type with language
      vim.treesitter.language.register("bash", "zsh")
      -- add more things to the ensure_installed table protecting against community packs modifying it
      if type(opts.ensure_installed) == "table" then vim.list_extend(opts.ensure_installed, { "comment" }) end
    end,
  },
}
