---@type LazySpec[]
return {

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        texlab = {
          keys = {
            {
              "<Leader>K",
              "<plug>(vimtex-doc-package)",
              desc = "Vimtex Docs",
              silent = true,
            },
          },
        },
      },
    },
  },
  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    config = function()
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable "pplatex" == 1
          and "pplatex"
        or "latexlog"

      -- add vimtex conceal to markdown
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "markdown",
        },
        callback = function()
          vim.schedule(function()
            if vim.b.current_syntax ~= nil then vim.b.current_syntax = nil end
            vim.cmd [[
              syn include @tex syntax/tex.vim
              syn region markdownMath start="\\\@<!\$" end="\$" skip="\\\$" contains=@tex,@NoSpell keepend
              syn region markdownMath start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@tex,@NoSpell keepend
            ]]

            vim.b.current_syntax = "markdown"
          end)
        end,
      })
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
      {
        "<leader>cm",
        "<Cmd>VimtexDocPackage<CR>",
        ft = "tex",
        desc = "Open Manual",
      },
    },
  },
  -- formatter

  -- linter

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- vimtex highlights clash with treesitter highlights
      disable = { "tex" },
      ensure_installed = { "bibtex" },
    },
  },

  -- test suite

  -- dap

  -- extra
  {
    "zspher/luasnip-latex-snippets.nvim",
    branch = "dev",
    ft = { "tex", "markdown" },
    opts = {
      allow_on_markdown = true,
    },
    dependencies = {
      "L3MON4D3/LuaSnip",
      "lervag/vimtex",
    },
  },
}
