---@type LazySpec[]
return {

  -- lsp

  -- formatter

  -- linter

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "git_config",
        "gitcommit",
        "git_rebase",
        "gitignore",
        "gitattributes",
      },
    },
  },

  -- test suite

  -- dap

  -- extra
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "Kaiser-Yang/blink-cmp-git",
    },

    opts = {
      sources = {
        default = { "git" },
        providers = {
          git = {
            name = "Git",
            module = "blink-cmp-git",
          },
        },
      },
    },
  },
}
