---@type LazySpec[]
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    opts = {
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        -- virtual_text = {
        --   spacing = 4,
        --   source = "if_many",
        --   prefix = "●",
        --   -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
        --   -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
        --   -- prefix = "icons",
        -- },
      },
      ---@type table<string, vim.lsp.Config>
      servers = {
        ["*"] = {
          keys = {
            {
              "<C-]>",
              function() Snacks.picker.lsp_definitions() end,
              desc = "Goto Definition",
            },
            {
              "grr",
              function() Snacks.picker.lsp_references() end,
              desc = "References",
            },
            {
              "gri",
              function() Snacks.picker.lsp_implementations() end,
              desc = "Goto Implementation",
            },
            {
              "grt",
              function() Snacks.picker.lsp_type_definitions() end,
              desc = "Goto T[y]pe Definition",
            },
            {
              "<leader>ss",
              function() Snacks.picker.lsp_symbols() end,
              desc = "LSP Symbols",
            },
            {
              "<leader>sS",
              function() Snacks.picker.lsp_workspace_symbols() end,
              desc = "LSP Workspace Symbols",
            },
            {
              "grc",
              function() Snacks.picker.lsp_incoming_calls() end,
              desc = "C[a]lls Incoming",
            },
            {
              "gro",
              function() Snacks.picker.lsp_outgoing_calls() end,
              desc = "C[a]lls Outgoing",
            },
            {
              "<leader>cR",
              function() Snacks.rename.rename_file() end,
              desc = "Rename File",
            },
            {
              "<leader>cl",
              function() Snacks.picker.lsp_config() end,
              desc = "Lsp Info",
            },
          },
        },
      },
      setup = {},
      codelens = {
        enabled = false,
        exclude = {},
      },
      inlay_hints = {
        enabled = true,
        exclude = {},
      },
    },
    config = function(_, opts)
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- inlay hints
      if opts.inlay_hints.enabled then
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if
              client
              and client:supports_method "textDocument/inlayHint"
              and vim.bo[buffer].buftype == ""
              and not vim.tbl_contains(
                opts.inlay_hints.exclude,
                vim.bo[buffer].filetype
              )
            then
              vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
            end
          end,
        })
      end

      if vim.lsp.inlay_hint then
        Snacks.toggle.inlay_hints():map "<leader>uh"
      end

      -- code lens
      if opts.codelens.enabled then
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if
              client
              and client:supports_method "textDocument/codeLens"
              and vim.bo[buffer].buftype == ""
              and not vim.tbl_contains(
                opts.codelens.exclude,
                vim.bo[buffer].filetype
              )
            then
              vim.lsp.codelens.enable(true, { bufnr = buffer })
            end
          end,
        })
      end

      if vim.lsp.codelens then
        Snacks.toggle({
          name = "Codelens",
          get = function() return vim.lsp.codelens.is_enabled { bufnr = 0 } end,
          set = function(state) vim.lsp.codelens.enable(state, { bufnr = 0 }) end,
        }):map "<leader>ue"
      end

      local function register_keys(client)
        if client == nil then return end

        local options = require("lazy.core.plugin").values(
          require("lazy.core.config").spec.plugins["nvim-lspconfig"],
          "opts",
          false
        )
        local maps = options.servers[client.name]
            and options.servers[client.name].keys
          or {}

        ---@type LazyKeysSpec[]
        local spec = options.servers["*"].keys

        vim.list_extend(spec, maps)

        local Keys = require "lazy.core.handler.keys"
        local keymaps = Keys.resolve(spec)
        for _, key in pairs(keymaps) do
          local cond = not (
            key.cond == false
            or ((type(key.cond) == "function") and not key.cond())
          )
          ---@diagnostic disable-next-line: inject-field
          key.cond = nil
          if cond then
            ---@class vim.keymap.set.Opts
            local o = Keys.opts(key) --[[@as vim.keymap.set.Opts]]
            o.buffer = true
            vim.keymap.set(key.mode or "n", key.lhs, key.rhs, o)
          end
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then register_keys(client) end
        end,
      })

      if opts.servers["*"] then vim.lsp.config("*", opts.servers["*"]) end

      local function configure(server)
        if server == "*" then return false end
        local server_opts = opts.servers[server] or {}

        local setup = opts.setup[server] or opts.setup["*"]
        if setup and setup(server, server_opts) then
          return true -- lsp will be setup by the setup function
        end

        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
      end

      for server, server_opts in pairs(opts.servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then configure(server) end
        end
      end
    end,
  },
  -- vim definitions
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
        { path = "nvim-lspconfig", words = { "lspconfig.settings" } },
      },
    },
    config = function(_, opts)
      require "lspconfig"
      require("lazydev").setup(opts)
    end,
  },
}
