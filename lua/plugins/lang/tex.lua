local function findMain()
  local main_file = "main.tex"
  local path = vim.uv.cwd() .. "/" .. main_file
  if vim.uv.fs_stat(path) ~= nil then
    return path
  else
    return "%f"
  end
end

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
                  findMain(),
                  "--synctex",
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
              "<leader>cb",
              "<Cmd>LspTexlabBuild<CR>",
              desc = "Build Pdf Document",
            },
            {
              "<leader>cv",
              "<Cmd>LspTexlabForward<CR>",
              desc = "Forward Search",
            },
            {
              "<leader>cx",
              "<Cmd>LspTexlabCancelBuild<CR>",
              desc = "Cancel Build",
            },
            {
              "<leader>cC",
              "<Cmd>LspTexlabCleanAuxiliary<CR>",
              desc = "Clean All",
            },
            {
              "<leader>cc",
              "<Cmd>LspTexlabCleanArtifacts<CR>",
              desc = "Clean Artifacts",
            },
            {
              "<leader>ce",
              "<Cmd>LspTexlabChangeEnvironment<CR>",
              desc = "Change Environmant",
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
