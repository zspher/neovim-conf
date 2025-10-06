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
        superhtml = {
          on_attach = function(client, _)
            client.server_capabilities.documentFormattingProvider = nil
            client.server_capabilities.completionProvider = nil
            client.server_capabilities.renameProvider = nil
          end,
        },
        emmet_language_server = {},

        -- general
        biome = {
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
