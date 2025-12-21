---@type LazySpec[]
return {
  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        tinymist = {
          single_file_support = true, -- Fixes LSP attachment in non-Git directories
          cmd_env = { SOURCE_DATE_EPOCH = "" },
          settings = {
            formatterMode = "typstyle",
            exportPdf = "onSave",
            semanticTokens = "disable",
          },
          keys = {
            {
              "<leader>cp",
              function()
                local lsp = vim.lsp.get_clients { bufnr = 0, name = "tinymist" }
                lsp[1]:exec_cmd({
                  title = "pin",
                  command = "tinymist.pinMain",
                  arguments = { vim.api.nvim_buf_get_name(0) },
                }, { bufnr = vim.api.nvim_get_current_buf() })
              end,
              desc = "Pin main file",
            },
            {
              "<leader>cb",
              "<Cmd>LspTinymistExportPdf<CR>",
              desc = "Build Pdf Document",
            },
          },
        },
      },
    },
  },

  -- formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        typst = { "typstyle", lsp_format = "prefer" },
      },
    },
  },
  -- linter

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "typst" },
    },
  },

  -- test suite

  -- dap

  -- extra
}
