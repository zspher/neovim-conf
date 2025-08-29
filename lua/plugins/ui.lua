---@module 'snacks'
---@type LazySpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    opts = function()
      local tsc = require "treesitter-context"
      Snacks.toggle({
        name = "Treesitter Context",
        get = tsc.enabled,
        set = function(state)
          if state then
            tsc.enable()
          else
            tsc.disable()
          end
        end,
      }):map "<leader>ut"
      return { mode = "cursor", max_lines = 3 }
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>bp",
        "<Cmd>BufferLineTogglePin<CR>",
        desc = "Toggle Pin",
      },
      {
        "<leader>bP",
        "<Cmd>BufferLineGroupClose ungrouped<CR>",
        desc = "Delete Non-Pinned Buffers",
      },
      {
        "<leader>br",
        "<Cmd>BufferLineCloseRight<CR>",
        desc = "Delete Buffers to the Right",
      },
      {
        "<leader>bl",
        "<Cmd>BufferLineCloseLeft<CR>",
        desc = "Delete Buffers to the Left",
      },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
        close_command = function(n) Snacks.bufdelete(n) end,
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        indicator = { style = "none" },
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "snacks_layout_box",
          },
        },
      },
    },
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    lazy = true,
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    main = "rainbow-delimiters.setup",
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    opts = {
      filetypes = {
        "*",
        qss = { css = true },
        css = { css = true },
      },
      user_default_options = {
        names = false,
        always_update = true,
        tailwind = "lsp",
      },
      buftypes = { "!nofile" },
    },
  },
  {
    "folke/snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      ---@type table<string, snacks.win.Config>
      styles = {},
      indent = {
        scope = {
          hl = "SnacksIndent1",
        },
      },
      image = {
        markdown = { enabled = true },
        max_width = 20,
        max_height = 10,
      },
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require "lualine_require"
      lualine_require.require = require

      vim.o.laststatus = vim.g.lualine_laststatus

      -- HACK: see lualine.nvim issue #1201, Illegal character from fzf could
      -- cause lualine to hang. To prevent this, we disable lualine from
      -- retrieving the content of the currently selected item in fzf, avoiding
      -- potential invalid characters.
      require("lualine.extensions.fzf").sections.lualine_y = {}

      local trouble = require "trouble"
      local symbols = trouble.statusline
        and trouble.statusline {
          mode = "symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal} ",
          hl_group = "lualine_c_normal",
        }
      local filename = {
        "filename",
        path = 3,
        symbols = {
          modified = "",
          readonly = "",
          unnamed = "",
          newfile = "",
        },
        color = "lualine_c_normal",
        cond = function() return not (vim.bo.bt == "nofile") end,
      }
      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = {
            statusline = {
              "dashboard",
              "alpha",
              "ministarter",
              "snacks_dashboard",
            },
            winbar = {
              "alpha",
              "dap-repl",
              "dap-view",
              "dap_disassembly",
              "dapui",
              "dashboard",
              "help",
              "ministarter",
              "qf",
              "snacks_dashboard",
              "trouble",
            },
          },

          section_separators = "",
          component_separators = { left = "", right = "|" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },

          lualine_c = {
            {
              "filetype",
              icon_only = true,
              padding = { left = 1, right = 0 },
            },
            "diagnostics",
            {
              function()
                local data = vim.fn.systemlist(
                  "magick identify " .. vim.api.nvim_buf_get_name(0)
                )[1]
                local width, height = data:match "%s(%d+)x(%d+)%s"

                return "h: " .. height .. " w: " .. width
              end,
              cond = function() return vim.bo.ft == "image" end,
            },
          },
          lualine_x = {
            Snacks.profiler.status(),
            {
              ---@diagnostic disable-next-line: undefined-field
              require("noice").api.status.command.get,
              ---@diagnostic disable-next-line: undefined-field
              cond = require("noice").api.status.command.has,
              color = function() return { fg = Snacks.util.color "Statement" } end,
            },
            {
              ---@diagnostic disable-next-line: undefined-field
              require("noice").api.status.mode.get,
              ---@diagnostic disable-next-line: undefined-field
              cond = require("noice").api.status.mode.has,
              color = function() return { fg = Snacks.util.color "Constant" } end,
            },
            {
              function() return "  " .. require("dap").status() end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = function() return { fg = Snacks.util.color "Debug" } end,
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return { fg = Snacks.util.color "Special" } end,
            },
          },
          lualine_y = {
            {
              "progress",
              separator = " ",
              padding = { left = 1, right = 0 },
            },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function() return " " .. os.date "%R" end,
          },
        },
        extensions = { "trouble", "lazy" },
        winbar = {
          lualine_c = {
            filename,
            {
              symbols and symbols.get,
              cond = symbols and symbols.has,
              separator = { left = "" },
              fmt = function(str) -- return string except for last "›"
                return str:gsub("(.*)([^]*)$", "%1")
              end,
            },
          },
        },
        inactive_winbar = {
          lualine_c = {
            filename,
          },
        },
      }
      return opts
    end,
  },

  -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        {
          filter = {
            event = "notify",
            any = {
              { find = "[iI]nitialize" },
              { find = "[sS]tart" },
            },
            warning = false,
            error = false,
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      {
        "<S-Enter>",
        function() require("noice").redirect(vim.fn.getcmdline()) end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<leader>snl",
        function() require("noice").cmd "last" end,
        desc = "Noice Last Message",
      },
      {
        "<leader>snh",
        function() require("noice").cmd "history" end,
        desc = "Noice History",
      },
      {
        "<leader>sna",
        function() require("noice").cmd "all" end,
        desc = "Noice All",
      },
      {
        "<leader>snd",
        function() require("noice").cmd "dismiss" end,
        desc = "Dismiss All",
      },
      {
        "<leader>snt",
        function() require("noice").cmd "pick" end,
        desc = "Noice Picker (Telescope/FzfLua)",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then return "<c-f>" end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then return "<c-b>" end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "n", "s" },
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then vim.cmd [[messages clear]] end
      require("noice").setup(opts)
    end,
  },

  -- icons
  {
    "nvim-mini/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },

  {
    "snacks.nvim",
    opts = {
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = false }, -- we set this in options.lua
      toggle = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      {
        "<leader>n",
        function()
          if Snacks.config.picker and Snacks.config.picker.enabled then
            Snacks.picker.notifications()
          else
            Snacks.notifier.show_history()
          end
        end,
        desc = "Notification History",
      },
      {
        "<leader>un",
        function() Snacks.notifier.hide() end,
        desc = "Dismiss All Notifications",
      },
    },
  },
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          ---@type snacks.dashboard.Item[]
          keys = {
            {
              icon = " ",
              key = "f",
              desc = "Find File",
              action = ":lua Snacks.dashboard.pick('files')",
            },
            {
              icon = " ",
              key = "n",
              desc = "New File",
              action = ":ene | startinsert",
            },
            {
              icon = " ",
              key = "g",
              desc = "Find Text",
              action = ":lua Snacks.dashboard.pick('live_grep')",
            },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = ":lua Snacks.dashboard.pick('oldfiles')",
            },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            {
              icon = " ",
              key = "s",
              desc = "Restore Session",
              section = "session",
            },
            {
              icon = " ",
              key = "x",
              desc = "Lazy Extras",
              action = ":LazyExtras",
            },
            {
              icon = "󰒲 ",
              key = "l",
              desc = "Lazy",
              action = ":Lazy",
            },
            {
              icon = " ",
              key = "q",
              desc = "Quit",
              action = ":qa",
            },
          },
        },
      },
    },
  },
}
