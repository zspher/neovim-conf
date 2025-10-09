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
            ["texlab"] = {
              build = {
                executable = "tectonic",
                args = {
                  "-X",
                  "compile",
                  "%f",
                  "--synctex",
                  "--keep-logs",
                  "--keep-intermediates",
                },
                forwardSearchAfter = true,
              },
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
            { "<leader>cb", "<Cmd>LspTexlabBuild<CR>", desc = "Texlab build" },
            {
              "<leader>cv",
              "<Cmd>LspTexlabForward<CR>",
              desc = "Texlab forward search",
            },
            {
              "<leader>cx",
              "<Cmd>LspTexlabCancelBuild<CR>",
              desc = "Texlab cancel build",
            },
            {
              "<leader>cC",
              "<Cmd>LspTexlabCleanAuxiliary<CR>",
              desc = "Texlab clean all",
            },
            {
              "<leader>cc",
              "<Cmd>LspTexlabCleanArtifacts<CR>",
              desc = "Texlab clean artifacts",
            },
            {
              "<leader>ce",
              "<Cmd>LspTexlabChangeEnvironment<CR>",
              desc = "Texlab change environmant",
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
    ft = { "tex", "markdown" },
    opts = {
      allow_on_markdown = true,
      use_treesitter = true,
    },
    dependencies = {
      "L3MON4D3/LuaSnip",
    },
  },
}
