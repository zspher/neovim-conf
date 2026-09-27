---@type LazySpec[]
return {
  -- lsp
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buf = bufnr,
              desc = desc,
            })
          end
          map(
            "n",
            "<localleader>t",
            "<cmd>RustLsp relatedTests<CR>",
            "Goto Related T[e]st"
          )
          map(
            "n",
            "<localleader>e",
            "<cmd>RustLsp explainError<CR>",
            "Explain Error"
          )
          map("n", "<localleader>o", "<cmd>RustLsp openCargo<CR>", "Open Cargo")
          map("n", "<localleader>d", "<cmd>RustLsp openDocs<CR>", "Open Docs")
        end,
        dap = { autoload_configurations = true },
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust if using rust-analyzer
            checkOnSave = true,
            -- Enable diagnostics if using rust-analyzer
            diagnostics = {
              enable = true,
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
            files = {
              excludeDirs = {
                ".direnv",
                ".git",
                ".github",
                ".gitlab",
                "bin",
                "node_modules",
                "target",
                "venv",
                ".venv",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim =
        vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
  -- {
  --   "Saecki/crates.nvim",
  --   event = { "BufRead Cargo.toml" },
  --   opts = {
  --     completion = {
  --       crates = {
  --         enabled = true,
  --       },
  --     },
  --     lsp = {
  --       enabled = true,
  --       actions = true,
  --       completion = true,
  --       hover = true,
  --     },
  --   },
  -- },

  -- formatter

  -- linter

  -- syntax highlight
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "rust", "ron" } },
  },

  -- test suite
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = {
      adapters = {
        ["rustaceanvim.neotest"] = {},
      },
    },
  },

  -- dap

  -- extra
}
