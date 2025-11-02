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
      servers = {},
      setup = {},
      codelens = {
        enabled = false,
      },
      inlay_hints = {
        enabled = false,
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
      if opts.codelens.enabled and vim.lsp.codelens then
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client:supports_method "textDocument/codeLens" then
              vim.lsp.codelens.refresh()
              vim.api.nvim_create_autocmd(
                { "BufEnter", "CursorHold", "InsertLeave" },
                {
                  buffer = bufnr,
                  callback = vim.lsp.codelens.refresh,
                }
              )
            end
          end,
        })
      end

      -- for conflicting keymap warnings
      vim.keymap.del("n", "grr")
      vim.keymap.del({ "n", "x" }, "gra")
      vim.keymap.del("n", "grn")
      vim.keymap.del("n", "gri")
      vim.keymap.del("n", "grt")

      local function register_keys(client)
        local picker = require "snacks.picker"

        ---@type LazyKeysSpec[]
        local spec = {
          {
            "gd",
            picker.lsp_definitions,
            desc = "Goto Definition",
            -- FIX: snacks.picker errors when using rzls.nvim
            cond = function() return vim.bo.ft ~= "razor" end,
          },
          { "gr", picker.lsp_references, desc = "References" },
          { "gI", picker.lsp_implementations, desc = "Goto Implementation" },
          {
            "gy",
            picker.lsp_type_definitions,
            desc = "Goto T[y]pe Definition",
          },
          { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
          {
            "]]",
            function() Snacks.words.jump(vim.v.count1) end,
            desc = "Next Reference",
            cond = Snacks.words.is_enabled(),
          },
          {
            "[[",
            function() Snacks.words.jump(-vim.v.count1) end,
            desc = "Prev Reference",
            cond = Snacks.words.is_enabled(),
          },
          { "<leader>ss", picker.lsp_symbols, desc = "LSP Symbols" },
          {
            "<leader>sS",
            picker.lsp_workspace_symbols,
            desc = "LSP Workspace Symbols",
          },
          {
            "gai",
            function() Snacks.picker.lsp_incoming_calls() end,
            desc = "C[a]lls Incoming",
          },
          {
            "gao",
            function() Snacks.picker.lsp_outgoing_calls() end,
            desc = "C[a]lls Outgoing",
          },
          {
            "<leader>ca",
            vim.lsp.buf.code_action,
            desc = "Code Action",
            mode = { "n", "x" },
          },
          {
            "<leader>cc",
            vim.lsp.codelens.run,
            desc = "Run Codelens",
            mode = { "n", "x" },
          },
          {
            "<leader>cC",
            vim.lsp.codelens.refresh,
            desc = "Refresh & Display Codelens",
          },
          { "<leader>cR", Snacks.rename.rename_file, desc = "Rename File" },
          { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
          { "<leader>cl", Snacks.picker.lsp_config, desc = "Lsp Info" },
        }

        local options = require("lazy.core.plugin").values(
          require("lazy.core.config").spec.plugins["nvim-lspconfig"],
          "opts",
          false
        )

        if client == nil then return end
        local maps = options.servers[client.name]
            and options.servers[client.name].keys
          or {}

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
            local o = Keys.opts(key) --[[@as vim.keymap.set.Opts]]
            o.buffer = true
            vim.keymap.set(key.mode or "n", key.lhs, key.rhs, o)
          end
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then return register_keys(client) end
        end,
      })

      if opts.capabilities then
        vim.lsp.config("*", { capabilities = opts.capabilities })
      end

      local function configure(server)
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
      },
    },
  },
}
