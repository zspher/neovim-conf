---@type LazySpec[]
return {

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        -- css
        cssmodules_ls = {},
        cssls = {
          settings = {
            css = { lint = { unknownAtRules = "ignore" } },
          },
        },
        tailwindcss = {},

        -- html
        superhtml = {},
        html = {
          settings = {
            html = { format = { indentInnerHtml = true } },
          },
        },
        emmet_language_server = {},

        -- general
        biome = {
          single_file_support = true,
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)
            on_dir(
              require("lspconfig.util").root_pattern(
                "biome.jsonc",
                "biome.json",
                ".git"
              )(fname)
            )
          end,
        },
      },
    },
  },
  -- formatter

  -- linter
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        html = { "markuplint" },
      },
    },
  },

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "css", "scss", "html" },
    },
  },

  -- test suite

  -- dap

  -- extra
}
