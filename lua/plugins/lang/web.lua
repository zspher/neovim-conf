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
        html = {
          capabilities = {
            workspace = {
              didChangeWorkspaceFolders = { dynamicRegistration = true },
            },
          },
        },
        superhtml = {},
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
          filetypes = {
            "astro",
            "css",
            "graphql",
            "javascript",
            "javascriptreact",
            "json",
            "jsonc",
            "svelte",
            "typescript",
            "typescript.tsx",
            "typescriptreact",
            "vue",
          },
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
