-- NOTE: snippets, completions & refactoring (anything that impacts the buffer)

---@module 'snacks'
---@type LazySpec[]
return {
  -- auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = function()
      Snacks.toggle({
        name = "autopair",
        get = function() return not require("nvim-autopairs").state.disabled end,
        set = function()
          require("nvim-autopairs").state.disabled =
            not require("nvim-autopairs").state.disabled
        end,
      }):map "<leader>up"
    end,
  },
  -- comments
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "VeryLazy",
    opts = {},
  },
  {
    "danymat/neogen",
    cmd = "Neogen",
    keys = {
      {
        "<leader>cn",
        function() require("neogen").generate() end,
        desc = "Generate Annotations (Neogen)",
      },
    },
    opts = {
      snippets_engine = "luasnip",
      languages = {
        cs = {
          template = { annotation_convention = "xmldoc" },
        },
      },
    },
  },

  -- autocomplete
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    build = "make install_jsregexp",
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load {
            paths = { vim.fn.stdpath "config" .. "/snippets" },
          }
        end,
      },
    },
    opts = {
      enable_autosnippets = true,
      cut_selection_keys = "<C-j>",
      history = true,
      delete_check_events = "TextChanged",
    },
    keys = {
      {
        "<C-j>",
        function() require("luasnip").jump(1) end,
        mode = { "s", "i" },
      },
      {
        "<C-k>",
        function() require("luasnip").jump(-1) end,
        mode = { "i", "s" },
      },
      {
        "<C-n>",
        function() require("luasnip").change_choice(1) end,
        mode = { "i", "s" },
      },
      {
        "<C-p>",
        function() require("luasnip").change_choice(-1) end,
        mode = { "i", "s" },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    optional = true,
    opts = function(_, opts)
      local types = require "luasnip.util.types"
      opts.ext_opts = {
        [types.choiceNode] = {
          active = {
            hl_group = "SnippetTabStop",
            virt_text = { { "{𝖢}", "Title" } },
          },
        },
      }
    end,
  },
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = "*",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
      -- add blink.compat to dependencies
      {
        "saghen/blink.compat",
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      completion = {
        menu = {
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "source_name" },
            },
            components = {
              source_name = {
                text = function(ctx) return "[" .. ctx.source_name .. "]" end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = { enabled = true },
      },
      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = {},
        default = { "lsp", "path", "snippets", "buffer" },
      },
      keymap = {
        preset = "default",
        ["<C-j>"] = { "snippet_forward", "fallback" },
        ["<C-k>"] = {
          "show_signature",
          "hide_signature",
          "snippet_backward",
          "fallback",
        },

        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },
      },
    },
    config = function(_, opts)
      -- setup compat sources
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if
          type(enabled) == "table"
          and not vim.tbl_contains(enabled, source)
        then
          table.insert(enabled, source)
        end
      end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      require("blink.cmp").setup(opts)
    end,
  },

  -- refactoring
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "lewis6991/async.nvim",
    },
    keys = {
      {
        "<leader>rI",
        function() return require("refactoring").inline_func() end,
        mode = { "n", "x" },
        desc = "Inline Function",
        expr = true,
      },
      {
        "<leader>ri",
        function() return require("refactoring").inline_var() end,
        mode = { "n", "x" },
        desc = "Inline Variable",
        expr = true,
      },
      {
        "<leader>re",
        function() return require("refactoring").extract_var() end,
        mode = { "n", "x" },
        desc = "Extract Variable",
        expr = true,
      },
      {
        "<leader>rf",
        function() return require("refactoring").extract_func() end,
        mode = { "n", "x" },
        desc = "Extract Function",
        expr = true,
      },
      {
        "<leader>rF",
        function() return require("refactoring").extract_func_to_file() end,
        mode = { "n", "x" },
        desc = "Extract Function To File",
        expr = true,
      },
      {
        "<leader>rp",
        function()
          return require("refactoring.debug").print_var {
            output_location = "below",
          } .. "iw"
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Debug Print Variable",
      },
      {
        "<leader>rc",
        function()
          return require("refactoring.debug").cleanup { restore_view = true }
        end,
        mode = { "n", "x" },
        expr = true,
        remap = true,
        desc = "Debug Cleanup",
      },
    },
    opts = {},
  },
}
