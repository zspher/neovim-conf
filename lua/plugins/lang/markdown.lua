---@type LazySpec[]
return {

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        marksman = {},
      },
    },
  },
  -- formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(
              function(d) return d.source == "markdownlint" end,
              vim.diagnostic.get(ctx.buf)
            )
            return #diag > 0
          end,
        },
      },
      formatters_by_ft = {
        ["markdown"] = { "markdownlint-cli2" },
        ["markdown.mdx"] = { "markdownlint-cli2" },
      },
    },
  },
  -- linter
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        -- i like the formatter but damn is this linter pedantic
        -- ["markdown"] = { "markdownlint-cli2" },
      },
    },
  },

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "markdown", "markdown_inline" },
    },
  },

  -- test suite

  -- dap

  -- extra
  {
    "brianhuster/live-preview.nvim",
    cmd = { "LivePreview" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        enabled = false,
      },
      bullet = {
        icons = { "•", "◦" },
        right_pad = 1,
      },
      latex = {
        enabled = false,
      },
      win_options = { conceallevel = { rendered = 2 } },
      checkbox = {
        custom = {
          todo = {
            raw = "[o]",
            rendered = " ",
            highlight = "RenderMarkdownSuccess",
            scope_highlight = "RenderMarkdownSuccess",
          },
          cancelled = {
            raw = "[-]",
            rendered = "- ",
            highlight = "Comment",
            scope_highlight = "RenderMarkdownCancelledTask",
          },
          important = {
            raw = "[!]",
            rendered = " ",
            highlight = "RenderMarkdownError",
            scope_highlight = "RenderMarkdownError",
          },
          next = {
            raw = "[>]",
            rendered = " ",
            highlight = "Comment",
            scope_highlight = "Comment",
          },
        },
      },
      dash = {
        ---@diagnostic disable-next-line: undefined-field
        width = tonumber(vim.opt.cc:get()[1]),
      },
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      ---@module 'snacks'
      Snacks.toggle({
        name = "Render Markdown",
        get = require("render-markdown").get,
        set = require("render-markdown").set,
      }):map "<leader>um"
    end,
  },
}
