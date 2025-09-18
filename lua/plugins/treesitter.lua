---@type LazySpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "diff",
        "query",
        "vim",
        "vimdoc",
      },
    },
    config = function(_, opts)
      local TS = require "nvim-treesitter"
      TS.setup(opts)

      local installed = {}
      for _, lang in ipairs(require("nvim-treesitter").get_installed "parsers") do
        installed[lang] = lang
      end

      local to_install = vim.tbl_filter(function(ft)
        local lang = vim.treesitter.language.get_lang(ft)
        return not (lang and installed[lang])
      end, opts.ensure_installed)
      if #to_install > 0 then TS.install(to_install, { summary = true }) end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local bufnr = args.buf
          local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
          if not ok or not parser then return end
          pcall(vim.treesitter.start)

          local ft = vim.bo[bufnr].filetype
          for _, value in ipairs(opts.ensure_installed) do
            if ft == value then vim.bo[bufnr].syntax = "on" end
          end
        end,
      })
    end,
  },
}
