local filetypes = { "tex", "plaintex", "bib" }

---@type LazySpec[]
return {

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        texlab = {
          settings = {
            texlab = {
              build = {
                filename = "default.pdf",
                pdfDirectory = "build/default",
                executable = "tectonic",
                args = {
                  "-X",
                  "build",
                  "--keep-logs",
                  "--keep-intermediates",
                },
                forwardSearchAfter = true,
                onSave = true,
              },
              chktex = { onOpenAndSave = true },
              forwardSearch = {
                executable = "zathura",
                args = {
                  "--synctex-forward",
                  "%l:1:%f",
                  "%p",
                },
              },
            },
          },
          keys = {
            {
              "<localleader>b",
              "<Cmd>LspTexlabBuild<CR>",
              desc = "Build Pdf Document",
              ft = filetypes,
            },
            {
              "<localleader>v",
              "<Cmd>LspTexlabForward<CR>",
              desc = "Forward Search",
              ft = filetypes,
            },
            {
              "<localleader>x",
              "<Cmd>LspTexlabCancelBuild<CR>",
              desc = "Cancel Build",
              ft = filetypes,
            },
            {
              "<localleader>C",
              "<Cmd>LspTexlabCleanAuxiliary<CR>",
              desc = "Clean All",
              ft = filetypes,
            },
            {
              "<localleader>c",
              "<Cmd>LspTexlabCleanArtifacts<CR>",
              desc = "Clean Artifacts",
              ft = filetypes,
            },
            {
              "<localleader>e",
              "<Cmd>LspTexlabChangeEnvironment<CR>",
              desc = "Change Environmant",
              ft = filetypes,
            },
          },
        },
      },
    },
  },
  -- formatter

  -- linter

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "bibtex", "latex" },
    },
  },

  -- test suite

  -- dap

  -- extra
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    ft = { "tex", "markdown", "plaintex" },
    opts = {
      allow_on_markdown = true,
      use_treesitter = true,
    },
    dependencies = {
      "L3MON4D3/LuaSnip",
    },
  },
}
