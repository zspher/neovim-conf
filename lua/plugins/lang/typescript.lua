---@type LazySpec[]
return {

  -- lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type table<string, vim.lsp.Config>
      servers = {
        vtsls = {
          ---@type lspconfig.settings.vtsls
          settings = {
            vtsls = {
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
          },
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                }
              end,
              desc = "Organize Imports",
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
      ensure_installed = { "tsx", "typescript", "javascript" },
    },
  },

  -- test suite
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        ["neotest-vitest"] = {},
      },
    },
  },

  -- dap
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require "dap"
      local js_filetypes =
        { "typescript", "javascript", "typescriptreact", "javascriptreact" }

      local function get_program()
        return coroutine.create(function(dap_run_co)
          local cwd = vim.uv.cwd()
          local items = { [vim.api.nvim_buf_get_name(0)] = true }

          local package_path = vim.fs.normalize(cwd .. "/package.json")
          local fd = vim.uv.fs_open(package_path, "r", 438)
          if fd then
            local stat = vim.uv.fs_fstat(fd)
            local raw = stat and vim.uv.fs_read(fd, stat.size, 0)
            vim.uv.fs_close(fd)
            local ok, data = pcall(vim.json.decode, raw or "{}")

            if ok and data then
              local bins = data.main and { data.main } or {}
              vim.list_extend(
                bins,
                type(data.bin) == "table" and data.bin or { data.bin }
              )
              for _, bin in ipairs(bins) do
                local path = vim.fs.normalize(cwd .. "/" .. bin)
                local f = vim.uv.fs_stat(path)
                if f and f.type == "file" then items[path] = true end
              end
            end
          end

          items = vim.tbl_keys(items)

          if #items == 1 then
            coroutine.resume(dap_run_co, items[1])
            return
          end
          vim.ui.select(items, {
            format_item = function(path) return vim.fn.fnamemodify(path, ":.") end,
          }, function(choice)
            if choice then coroutine.resume(dap_run_co, choice) end
          end)
        end)
      end
      for _, language in ipairs(js_filetypes) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = "node",
              request = "launch",
              name = "Launch file",
              program = get_program,
              cwd = "${workspaceFolder}",
              console = "integratedTerminal",
            },
            {
              type = "node",
              request = "attach",
              name = "Attach",
              processId = "${command:pickProcess}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "chrome",
              request = "launch",
              name = "Start brave on port",
              runtimeExecutable = vim.fn.exepath "brave",
              webRoot = "${workspaceFolder}",
              url = function() return vim.fn.input("args", "http://localhost:") end,
            },
          }
        end
      end
    end,
  },

  -- extra
  {
    "nvim-mini/mini.icons",
    optional = true,
    opts = {
      file = {
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
      },
    },
  },
}
